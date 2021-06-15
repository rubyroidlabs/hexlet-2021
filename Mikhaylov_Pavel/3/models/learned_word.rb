# frozen_string_literal: true

# rubocop:disable Rails/ApplicationRecord

require 'active_record'

class LearnedWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
end

# rubocop:enable Rails/ApplicationRecord
