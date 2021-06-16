# frozen_string_literal: true

require 'sinatra/base'

module Fasteng
  class WebhookController < BaseController
    class SinatraBase < Sinatra::Base
      configure do
        set :port, 3000
      end
    end
  end
end
