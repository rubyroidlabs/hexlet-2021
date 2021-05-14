# frozen_string_literal: true

class Filter
  def initialize(options)
    @options = options
  end

  def filter_domains(domains)
    return domains unless @options[:no_subdomains]

    domains.reject(&:subdomain?)
  end
end
