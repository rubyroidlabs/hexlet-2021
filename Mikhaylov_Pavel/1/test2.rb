def score(dice)
  (1..6).reduce(0) do |points, num|
    dropouts = dice.count(num)
    if dropouts >= 3
      points += num == 1 ? 1000 : num * 100
      dropouts -= 3
    end
    points += 100 * dropouts if num == 1
    points += 50 * dropouts if num == 5
    points
  end
end

puts score([])