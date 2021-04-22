# frozen_string_literal: true

require 'yaml'

# Config
class Config
  CONFIG_FILE = 'config.yaml'
  class << self
    def get(key)
      config[key.to_s]
    end

    def config
      @config ||= YAML.safe_load(File.read(file_path))
    end

    def file_path
      File.join(File.expand_path('..', __dir__), 'config', CONFIG_FILE.to_s)
    end
  end
end
