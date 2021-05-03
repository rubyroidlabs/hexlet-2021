# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :user_words, dependent: :destroy
  has_many :words, through: :user_words
end
