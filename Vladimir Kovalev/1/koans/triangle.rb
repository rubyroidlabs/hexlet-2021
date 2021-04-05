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

	sides.each do |s|
		fail TriangleError if s <= 0
	end

	x,y,z = sides.sort
	fail TriangleError if (x + y) <= z

	return :equilateral if sides.uniq.count == 1
	return :isosceles if sides.uniq.count == 2
	:scalene

  # WRITE THIS CODE
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
