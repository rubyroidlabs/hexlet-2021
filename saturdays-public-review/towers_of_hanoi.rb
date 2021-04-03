# Towers of Hanoi
# http://en.wikipedia.org/wiki/Towers_of_hanoi

$moves_count = 0

class TowersOfHanoi
  attr_reader :towers
  
  def initialize
    @n = 3

    first_col = Array.new(@n) { |x| x + 1 }.reverse

    @towers = [first_col, [], []]
  end
  
  def rules
    puts "
      The Towers of Hanoi is a mathematical game or puzzle. It consists of 
      three rods and three disks of different sizes which can slide onto any 
      rod. The puzzle starts with the disks in a stack of descending sizes 
      on the leftmost rod.

      Move the entire stack to the rightmost rod under these rules:

        1. Only one disk can be moved at a time.
        2. Each move consists of taking the upper disk from one of the stacks 
           and placing it on top of another stack i.e. a disk can only be moved 
           if it is the uppermost disk on a stack.
        3. No disk may be placed on top of a smaller disk."
  end
  
  def offer_rules
    puts "Want to see the rules? (yes/no)"
    ans = gets
    if ans.start_with?('y')
      rules
    end
  end
  
  def sets
    @sets = towers.map do |column| 
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
    @towers = @towers.map{|column| column.reject{|x| x == " "} }
    @sets
  end
  
  def render
    puts "1st|2nd|3rd"
    puts " #{sets[0][2]} | #{sets[1][2]} | #{sets[2][2]}"
    puts " #{sets[0][1]} | #{sets[1][1]} | #{sets[2][1]}"
    puts " #{sets[0][0]} | #{sets[1][0]} | #{sets[2][0]}"
  end
  
  def locate(disk)
    if towers[0].include? disk
      from_tower = @towers[0]
    elsif towers[1].include? disk
      from_tower = @towers[1]
    else
      from_tower = @towers[2]
    end
    from_tower
  end
  
  def get_user_number
    gets.chomp.to_i
  end

  def check_boundaries(disk)
    (1..@n).to_a.include?(disk)
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
      next_disk = to_tower.last
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
    render 
    puts "\n"
    
    puts "Which disk would you like to move?"

    disk = get_user_number

    while !check_boundaries(disk)
      puts "There's no such di, choose another."
      disk = get_user_number
    end

    from_tower = locate(disk)

    while from_tower.last != disk
      puts "Can't take a disk if it's not at the top!"
      puts "Choose another disk to move."
      disk = get_user_number
      from_tower = locate(disk)
    end

    puts "To which tower?"
    tower_number = get_user_number
    to_tower = @towers[tower_number - 1]

    while tower_number > towers.size
      to_tower = @towers[tower_number - 1]
      if !to_tower
        puts "There's no such tower, choose another." 
      end
      tower_number = get_user_number
    end

    while valid_move(disk, from_tower, to_tower) == false
        user_choice = turn_invalid_move_valid(disk)
        user_choice == 1 ? break : to_tower = user_choice
    end
    
    if valid_move(disk, from_tower, to_tower)
      move(disk, from_tower, to_tower)
      $moves_count = $moves_count + 1
    end
  end
  
  def won?
    towers == [[], [], Array(Range.new(1, 3)).reverse] || 
      towers == [[], Array(Range.new(1, 3)).reverse, []]
  end
  
  def winning_message
    puts "\nYou won!!\n"
    render
    puts "\nYou finished the game in #{$moves_count} moves!"
    puts "Thanks for playing :)"
  end
  
  def play
    puts "Welcome to the game!"
    offer_rules
    puts "Press enter to play!"
    gets
    playing_loop while won? == false
    winning_message
  end
end

if __FILE__ == $PROGRAM_NAME
  game = TowersOfHanoi.new
  game.play
end
