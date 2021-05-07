# frozen_string_literal: true

class Definition < ActiveRecord::Base
  has_many :learned_definitions, dependent: :destroy
  has_many :users, through: :learned_definitions
end
