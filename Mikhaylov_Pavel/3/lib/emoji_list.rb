# frozen_string_literal: true

require 'unicode/emoji'

class EmojiList
  def self.list
    result = []
    Unicode::Emoji.list('Smileys & Emotion').each do |_k, v|
      result << v
    end
    result.flatten
  end
end
