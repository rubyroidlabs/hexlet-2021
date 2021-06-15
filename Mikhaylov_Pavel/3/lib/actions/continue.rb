# frozen_string_literal: true

require './models/user'
require_relative './base'

module Actions
  class Continue < Base
    def call
      find_user.learn!
      super
    end
  end
end
