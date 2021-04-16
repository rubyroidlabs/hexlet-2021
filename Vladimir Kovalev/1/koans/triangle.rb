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
def triangle(a, b, c)
	sides = [a,b,c]

	fail TriangleError if sides.any? { |s| s <= 0 }

	x,y,z = sides.sort
	fail TriangleError if (x + y) <= z

	case sides.uniq.count
	when 1
		:equilateral
	when 2
		:isosceles
	else
		:scalene
	end
  # WRITE THIS CODE
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end