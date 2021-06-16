# frozen_string_literal: true

require_relative '../../models/user'
require_relative './base'

module Actions
  class Continue < Base
    def call
      user = find_user
      user.learn! unless user.learning?
      super
    end
  end
end
