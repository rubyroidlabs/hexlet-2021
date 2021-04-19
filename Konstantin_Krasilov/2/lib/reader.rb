# frozen_string_literal: true

require 'csv'
require_relative 'link'
# Reader
module Reader
  module_function

  OPEN_SOURCE = /(gitlab|phabricator|redmine|rhodecode|github|bitbucket|gogs|gitea|sourcehut)/

  def from_csv(path, options = {})
    CSV.read(path).filter_map do |url|
      next if options.key?(:solutions) && url.join.match?(OPEN_SOURCE)
      next if options.key?(:subdomains) && url.join.count('.') > 1

      Link.new(url.join)
    end
  end
end
