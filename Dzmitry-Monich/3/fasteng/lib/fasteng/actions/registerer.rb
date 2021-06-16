# frozen_string_literal: true

module Fasteng
  module Actions
    class Registerer < Base
      def call
        user.register!
        send(:welcome)
      end
    end
  end
end
