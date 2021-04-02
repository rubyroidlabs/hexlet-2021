# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#

def validate(*sides)
  all_zero = ->(args) { args.all?(&:zero?) }
  any_negative = ->(args) { args.any?(&:negative?) }
  one_bigger_or_equal_than_sum_of_others = ->(args) do
    *rest, last = args.sort
    last >= rest.sum
  end

  [all_zero, any_negative, one_bigger_or_equal_than_sum_of_others]
    .each { |check| raise TriangleError.new if check.call(sides) }
end

def triangle(a, b, c)
  validate(a, b, c)

  return :equilateral if a == b && b == c
  return :scalene if a != b && b != c && a != c

  :isosceles
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
