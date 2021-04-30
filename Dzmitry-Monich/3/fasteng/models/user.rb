# frozen_string_literal: true

# rubocop:disable Lint/RedundantCopDisableDirective
# rubocop:disable Rails/ApplicationRecord

class User < ActiveRecord::Base
  include Logging

  SCHEDULE_TYPES = [
    [15],
    [10, 21],
    [9, 15, 21],
    [8, 13, 18, 23],
    [8, 12, 16, 20, 24],
    [8, 11, 14, 17, 20, 23]
  ].freeze

  validates :telegram_id, presence: true, uniqueness: true, case_sensitive: false

  has_many :learned_words, dependent: :destroy
  has_many :definitions, through: :learned_words

  def add_schedule!(count)
    sched = SCHEDULE_TYPES[count.to_i - 1]
    update!(
      status: 'scheduled',
      schedule: schedule_to_s(sched),
      upcoming_time: init_upcoming(sched)
    )
  end

  def receive_definition!(definition)
    transaction do
      update!(status: 'waiting', upcoming_time: next_time)
      definitions << definition
    end
  end

  def upcoming_time_equal?(time)
    time == upcoming_time
  end

  def miss_time?(time)
    logger.info "miss-time: #{time} - #{previous_time}"
    status == 'waiting' && time - previous_time == 2
  end

  private

  def next_time
    intervals = schedule_to_a
    next_idx = (intervals.find_index { |i| i == upcoming_time } + 1) % intervals.size
    intervals[next_idx]
  end

  def previous_time
    intervals = schedule_to_a
    size = intervals.size
    prev_idx = (intervals.find_index { |i| i == upcoming_time } + (size - 1)) % size
    intervals[prev_idx]
  end

  def init_upcoming(intervals)
    intervals.find { |i| i > actual_time } || intervals.first
  end

  def schedule_to_s(intervals)
    intervals.join(',')
  end

  def schedule_to_a
    schedule.split(',').map(&:to_i)
  end

  # rubocop:disable Rails/TimeZone
  def actual_time
    Time.now.hour
    # Time.now.min
  end
  # rubocop:enable Rails/TimeZone
end

# rubocop:enable Rails/ApplicationRecord
# rubocop:enable Lint/RedundantCopDisableDirective
