# frozen_string_literal: true

class Definition < ActiveRecord::Base
  validates :word, presence: true, uniqueness: true
  validates :description, presence: true
end
