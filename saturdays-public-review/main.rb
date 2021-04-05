require_relative './towers_of_hanoi'

if __FILE__ == $PROGRAM_NAME
  game = TowersOfHanoi.new
  game.play
end