# frozen_string_literal: true

# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

module Greed
  class Player
    attr_reader :name
    attr_accessor :score

    def initialize(name)
      @name = name
      @score = 0
    end

    def to_s
      name
    end
  end

  class DiceSet
    attr_reader :values

    def roll(limit)
      self.values = Array.new(limit) { rand(1..6) }
    end

    private

    attr_writer :values
  end

  class Console
    class << self
      def welcome_message
        puts 'Game starts'
      end

      def finished_message(players, winner)
        puts "The winner is #{winner.name}"
        players.each { |p| puts "[Player] #{p.name}: [score]: #{p.score}" }
      end

      def log(dice, score, state, current_player)
        puts "Player: #{current_player.name}, score: #{current_player.score}"
        puts "Dice: #{dice.inspect}"
        puts "Score: #{score}"
        puts "Dices left: #{state[:dice_left]}"
        puts "Bank: #{state[:score]}"
      end

      def input_names
        puts 'Input players names (ENTER to exit)'

        names = []
        loop do
          text = gets.chomp.strip
          break if text.empty?

          names << text
        end
        abort 'No players, start another time' if names.empty?

        names
      end

      def next_turn?
        puts 'Input Y to make another try of ENTER to finish'
        answer = gets.chomp.downcase
        answer == 'y' && true
      end
    end
  end

  class Game
    DATA_FOR_REST = { 1 => 100, 5 => 50 }.freeze
    DICE_COUNT = 5

    def initialize(max_score = 1000, min_score = 300)
      @max_score = max_score
      @min_score = min_score

      @players = add_players
      @dice = DiceSet.new

      @state = {
        player_index: 0,
        score: 0,
        dice_left: DICE_COUNT
      }
    end

    def start
      Console.welcome_message
      flow
      finish
    end

    private

    attr_accessor :state
    attr_reader :players, :dice, :min_score, :max_score

    def flow
      result = next_turn
      if result.zero?
        change_player
        return flow
      end
      return flow if Console.next_turn?

      save_result
      return if win?

      change_player
      flow
    end

    # def flow
    #   loop do
    #     result = next_turn
    #     change_player and redo if result.zero?
    #     redo if Console.next_turn?

    #     save_result
    #     return if win?

    #     change_player
    #   end
    # end

    def next_turn
      dice.roll(state[:dice_left])
      result, rest_dice = score(dice.values)
      state[:dice_left] = rest_dice.zero? ? DICE_COUNT : rest_dice
      state[:score] += result

      Console.log(dice.values, result, state, current_player) # !!

      result
    end

    def change_player
      state[:player_index] = (state[:player_index] + 1) % players.size
      state[:score] = 0
      state[:dice_left] = DICE_COUNT
    end

    def save_result
      current_player.score += state[:score] if updated_score?
    end

    def win?
      current_player.score >= max_score
    end

    def updated_score?
      state[:score] >= min_score
    end

    def finish
      Console.finished_message(players, current_player)
    end

    def add_players
      names = Console.input_names
      names.map { |name| Player.new(name) }
    end

    def score(dice)
      three, rest =
        dice.each_with_object(Hash.new(0)) { |item, acc| acc[item] += 1 }
            .partition { |_, v| v >= 3 }

      calc_three = ->(num) { num == 1 ? 1000 : num * 100 }
      calc_rest = lambda do |array|
        array.reduce(0) { |acc, (k, v)| acc + DATA_FOR_REST.fetch(k, 0) * v }
      end
      calc_rest_count = lambda do |array|
        array.reject { |k, _| DATA_FOR_REST.key?(k) }
             .sum { |_, v| v }
      end

      return [calc_rest.call(rest), calc_rest_count.call(rest)] if three.empty?

      number, value = three.first
      rest << [number, value - 3]

      score = calc_three.call(number) + calc_rest.call(rest)
      rest_count = calc_rest_count.call(rest)

      [score, rest_count]
    end

    def current_player
      players[state[:player_index]]
    end
  end
end

if $PROGRAM_NAME == __FILE__
  game = Greed::Game.new
  game.start
end
