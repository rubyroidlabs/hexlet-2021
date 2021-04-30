# frozen_string_literal: true

# rubocop:disable Lint/RedundantCopDisableDirective
# rubocop:disable Rails/ApplicationRecord

class LearnedWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :definition
end

# rubocop:enable Rails/ApplicationRecord
# rubocop:enable Lint/RedundantCopDisableDirective
