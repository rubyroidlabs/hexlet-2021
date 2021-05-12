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

  has_many :learned_words, dependent: :destroy
  has_many :definitions, through: :learned_words

  validates :telegram_id, presence: true, uniqueness: true, case_sensitive: false
  validates :status, inclusion: { in: %w[new registered scheduled waiting] }
  validates :words_count, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6 }, allow_nil: true

  def add_schedule!(count)
    sched = SCHEDULE_TYPES[count.to_i - 1]
    update!(
      status: 'scheduled',
      words_count: count.to_i,
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
    intervals = SCHEDULE_TYPES[words_count - 1]
    next_idx = (intervals.find_index { |i| i == upcoming_time } + 1) % intervals.size
    intervals[next_idx]
  end

  def previous_time
    intervals = SCHEDULE_TYPES[words_count - 1]
    size = intervals.size
    prev_idx = (intervals.find_index { |i| i == upcoming_time } + (size - 1)) % size
    intervals[prev_idx]
  end

  def init_upcoming(intervals)
    intervals.find { |i| i > actual_time } || intervals.first
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
