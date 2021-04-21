# frozen_string_literal: true

require_relative '../lib/app'

module Helpers
  def run_app(options = {})
    app = Checker::App.new({ file: 'test.csv', **options })
    app.run
    app
  end
end
