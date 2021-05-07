# frozen_string_literal: true

class LearnedDefinition < ActiveRecord::Base
  belongs_to :user
  belongs_to :definition

  scope :by_user_id, ->(id) { where('user_id = ?', id) }
end
