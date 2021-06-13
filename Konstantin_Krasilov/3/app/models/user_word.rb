# frozen_string_literal: true

class UserWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
end
