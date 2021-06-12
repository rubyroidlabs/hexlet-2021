# frozen_string_literal: true

require_relative '../lib/models/definition'
Definition.destroy_all

ActiveRecord::Base.record_timestamps = true

Definition.create(letter: 'A', word: 'A-', description: ['prefix (also an- before a vowel sound) not.'])
Definition.create(letter: 'A', word: 'Aa', description: ['abbr. 1 automobile association. 2 alcoholics anonymous.'])
# and so on
