
# frozen_string_literal: true

require 'active_record'

class LearnedWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :definition
end
