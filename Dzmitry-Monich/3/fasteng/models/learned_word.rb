# frozen_string_literal: true

class LearnedWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :definition
end
