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
require 'pry'
def triangle(a, b, c)

  raise TriangleError, 'triangle should not have any sides of length 0' if [a, b, c].sum.zero?
  raise TriangleError, "negative length doesn't make sense." if [a, b, c].min.negative?

  x, y, z = [a, b, c].sort
  raise TriangleError, 'any two sides of a triangle should add up to more than the third side' if x + y <= z

  return :equilateral if a == b && a == c
  return :isosceles if a == b || b == c || c == a

  :scalene
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
