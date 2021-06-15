# frozen_string_literal: true

require './models/user'
require_relative './base'

module Actions
  class Stop < Base
    def call
      find_user.stop!
      super
    end
  end
end
