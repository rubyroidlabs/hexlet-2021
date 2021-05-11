# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/machinery'

class DomainCheckerTest < Minitest::Test
  def test_initial_status_is_unchecked
    assert_equal :unchecked, DomainChecker.new('example.com').status
  end

  def test_unchecked_result_is_correct
    assert_equal "example.com - hasn't been checked",
                 DomainChecker.new('example.com').result
  end

  def test_valid_domain_checked_status_is_got_response
    assert_equal :got_response, DomainChecker.new('example.com').check!.status
  end

  def test_valid_domain_checked_result_is_correct
    assert_match(/example.com - 200 \(\d+ms\)/,
                 DomainChecker.new('example.com').check!.result)
  end

  def test_invalid_domain_checked_status_is_errored
    assert_equal :errored, DomainChecker.new('example.com.invld').check!.status
  end

  def test_invalid_domain_checked_result_is_correct
    assert_match(/example.com.invld - ERROR/,
                 DomainChecker.new('example.com.invld').check!.result)
  end
end

class DomainsListTest < Minitest::Test
  TEST_DOMAINS_FILE = "#{File.dirname(__FILE__)}/fixtures/domains.csv"

  def test_csv_file_is_read_correctly
    assert_equal ['example.com', 'subdomain.example.com', 'gitlab.com'],
                 DomainsList.new(TEST_DOMAINS_FILE, {}).list.map(&:domain)
  end

  def test_no_subdomains_option_rejects_subdomains
    assert_equal ['example.com', 'gitlab.com'],
                 DomainsList.new(TEST_DOMAINS_FILE, { 'no-subdomains': true }).list.map(&:domain)
  end

  def test_exclude_solutions_rejects_gitlab
    assert_equal ['example.com', 'subdomain.example.com'],
                 DomainsList.new(TEST_DOMAINS_FILE, { 'exclude-solutions': true }).list.map(&:domain)
  end

  def test_filter_word_rejects_results_with_word_in_body
    assert_equal ['subdomain.example.com', 'gitlab.com'],
                 DomainsList.new(TEST_DOMAINS_FILE, { filter: 'example' }).process!.list.map(&:domain)
  end
end
