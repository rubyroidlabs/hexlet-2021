# frozen_string_literal: true

module Fasteng
  module DictionaryManager
    module DictionarySelector
      class << self
        def select_word(user)
          Definition
            .left_outer_joins(:learned_words)
            .where('user_id is NULL OR user_id NOT IN (?)', user.id)
            .order(Arel.sql('RANDOM()'))
            .first
        end
      end
    end
  end
end
