# frozen_string_literal: true

module Generator
  def generate_word
    arr = ('A'..'Z').to_a
    letter = arr[rand(arr.count)]
    ids = Definition.where(letter: letter).select(:id)
    def_id = ids[rand(ids.count)].id
    definition = Definition.where(id: def_id).first
    user_id = User.by_id(@telegram_id).first.id
    LearnedDefinition.create(user_id: user_id, definition_id: def_id, sent_qty: 1)
    @msg = "#{definition.word.upcase} - #{definition.description}"
  end
end
