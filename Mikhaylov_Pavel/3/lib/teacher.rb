# frozen_string_literal: true

class Teacher
  attr_reader :user

  def initialize(message)
    @user = User.find_by(telegram_id: message.from.id)
  end

  def teach; end
end
