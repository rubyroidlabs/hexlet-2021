# frozen_string_literal: true

require 'unicode/emoji'

class AcceptableEmojis
  def self.list
    Unicode::Emoji.list('Smileys & Emotion').values.flatten
  end
end
