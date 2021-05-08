# frozen_string_literal: true

require 'active_record'

class Word < ActiveRecord::Base
  def to_s
    "#{value} - #{definition}"
  end

  has_many :users, through: :learned_words
  has_many :learned_words, dependent: :destroy
end
