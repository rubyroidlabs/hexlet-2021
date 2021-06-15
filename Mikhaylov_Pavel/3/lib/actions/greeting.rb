# frozen_string_literal: true

require_relative '../../models/user'
require_relative './base'

module Actions
  class Greeting < Base
    def call
      record_user!
      super
    end

    def record_user!
      User.find_or_create_by!(
        telegram_id: message.from.id,
        name: message.from.first_name
      )
    end
  end
end
