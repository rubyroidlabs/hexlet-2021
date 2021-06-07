# frozen_string_literal: true

# rubocop:disable Rails/ApplicationRecord

require 'active_record'

class LearnedWord < ActiveRecord::Base
  belongs_to :users
  belongs_to :words
end

# rubocop:enable Rails/ApplicationRecord
