# frozen_string_literal: true

require './models/user'
require_relative './base'

module Actions
  class Accept < Base
    def call
      user = find_user
      user.update!(words_per_day: message.text.to_i)
      user.learn! unless user.learning?
      super
    end
  end
end
