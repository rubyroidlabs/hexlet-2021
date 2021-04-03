# Towers of Hanoi
# http://en.wikipedia.org/wiki/Towers_of_hanoi

class TowersOfHanoi
  attr_reader :towers, :correct_tower
  attr_accessor :moves_count
  
  def initialize
    @moves_count = 0
    @correct_tower = (1..3).to_a.reverse
    first_col = 3.downto(1).to_a

    @towers = [first_col, [], []]
  end
  
  # TODO: move to constant
  def get_rules
    <<~RULES
      The Towers of Hanoi is a mathematical game or puzzle. It consists of 
      three rods and three disks of different sizes which can slide onto any 
      rod. The puzzle starts with the disks in a stack of descending sizes 
      on the leftmost rod.

      Move the entire stack to the rightmost rod under these rules:

        1. Only one disk can be moved at a time.
        2. Each move consists of taking the upper disk from one of the stacks 
           and placing it on top of another stack i.e. a disk can only be moved 
           if it is the uppermost disk on a stack.
        3. No disk may be placed on top of a smaller disk.
    RULES
  end
  
  def offer_rules
    puts "Want to see the rules? (yes/no)"
    ans = gets.chomp
    if ans == 'yes'
      puts get_rules
    end
  end
  
  def get_sets
    sets = towers.map do |column|
      if column.empty? 
        column = [" ", " ", " "]
      elsif column.length < 3 && column.length > 1
        column << " "
      elsif column.length < 2
        column << " "
        column << " "
      else
        column
      end
    end
    @towers = @towers.map{ |column| column.reject{ |x| x == " " } }
    sets
  end
  
  def render_towers
    puts "1st|2nd|3rd"
    puts " #{get_sets[0][2]} | #{get_sets[1][2]} | #{get_sets[2][2]}"
    puts " #{get_sets[0][1]} | #{get_sets[1][1]} | #{get_sets[2][1]}"
    puts " #{get_sets[0][0]} | #{get_sets[1][0]} | #{get_sets[2][0]}"
  end
  
  def locate(disk)
    if towers[0].include?(disk)
      towers[0]
    elsif towers[1].include?(disk)
      towers[1]
    else
      towers[2]
    end
  end
  
  def get_disk
    puts "Which disk would you like to move?"
    disk = gets.to_i
    
    until (1..3).include?(disk)
      puts "There's no such disk, choose another."
      disk = gets.to_i
    end
    disk
  end
  
  def move(disk=nil, from_tower, to_tower)
    if disk == nil && to_tower.class == Fixnum
      disk = @towers[from_tower].pop
      @towers[to_tower] << disk
    else
      to_tower << disk
      from_tower.delete(disk)
    end
  end
  
  def valid_move disk=nil, from_tower, to_tower
    if disk.nil? && from_tower.class == Fixnum
      disk = towers[from_tower].pop
      return false if disk.nil?
      next_disk = towers[to_tower].last
    else
      next_disk = to_tower.last
    end
    
    if next_disk.nil? || next_disk > disk
      true 
    elsif disk > next_disk
      false 
    end
  end
  
  def turn_invalid_move_valid(disk)
    puts "Can't move the disk there, the next disk at that tower is smaller 
          than the disk you selected. You can choose another disk or choose 
          another tower for disk ##{disk}.\n"
    puts "Enter 1 to choose another disk, or 2 to choose another tower:"
    user_choice = gets.chomp.to_i
    while user_choice != 1 && user_choice != 2
      puts "Didn't catch that?"
      user_choice = gets.chomp.to_i
    end
    if user_choice == 1
      return 1
    else
      to_tower = nil
      while to_tower == nil
        puts "To which tower?"
        to_tower = gets.chomp.to_i
        to_tower = towers[to_tower - 1]
        if !to_tower.nil?
          break
        end
        puts "There's no such tower, choose another." 
      end
      to_tower
    end
  end
  
  def playing_loop
    puts "Here are the towers and their disks:\n\n"
    render_towers
    puts "\n"
    
    disk = get_disk
    from_tower = locate disk
    
    while from_tower.last != disk
      puts "Can't take a disk if it's not at the top!"
      puts "Choose another disk to move."
      disk = gets.chomp.to_i
      from_tower = locate(disk)
    end
    
    to_tower = nil
    loop do
      puts "To which tower?"
      to_tower = gets.to_i
      to_tower = towers[to_tower - 1]
      break unless to_tower.nil?
      puts "There's no such tower, choose another." 
    end
    
    while valid_move(disk, from_tower, to_tower) == false
        user_choice = turn_invalid_move_valid(disk)
        user_choice == 1 ? break : to_tower = user_choice
    end
    
    if valid_move(disk, from_tower, to_tower)
      move(disk, from_tower, to_tower)
      self.moves_count += 1
    end
  end
  
  def won?
    towers == [[], [], correct_tower] || 
      towers == [[], correct_tower, []]
  end
  
  def winning_message
    puts "\nYou won!!\n"
    render_towers
    puts "\nYou finished the game in #{moves_count} moves!"
    puts "Thanks for playing :)"
  end
  
  def play
    puts "Welcome to the game!"
    offer_rules
    puts "Press enter to play!"
    gets
    playing_loop until won?
    winning_message
  end
end

# TODO: check
if __FILE__ == $PROGRAM_NAME
  game = TowersOfHanoi.new
  game.play
end
