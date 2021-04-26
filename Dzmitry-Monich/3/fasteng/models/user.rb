# frozen_string_literal: true

class User < ActiveRecord::Base
  SCHEDULE_TYPES = [
    [15],
    [10, 21],
    [9, 15, 21],
    [8, 13, 18, 23],
    [8, 12, 16, 20, 24],
    [8, 11, 14, 17, 20, 23]
  ].freeze

  validates :telegram_id, presence: true, uniqueness: true

  def add_schedule!(count)
    hours = SCHEDULE_TYPES[count.to_i - 1]
    update!(
      status: 'scheduled',
      schedule: stringify_schedule(hours),
      current_time: init_current(hours)
    )
  end

  def add_notification!
    hours = parse_schedule
    next_idx = (hours.find_index { |h| h == current_time } + 1) % hours.size
    update!(
      status: 'waiting',
      current_time: hours[next_idx]
    )
  end

  private

  def init_current(hours)
    hours.find { |h| h > Time.now.hour } || hours.first
  end

  def stringify_schedule(hours)
    hours.join(',')
  end

  def parse_schedule
    schedule.split(',').map(&:to_i)
  end
end
