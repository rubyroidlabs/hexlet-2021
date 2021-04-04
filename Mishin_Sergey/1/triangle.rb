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
  validate(a, b, c)

  return :equilateral if a == b && b == c
  return :isosceles if a == b || a == c || b == c

  :scalene
end

def validate(a, b, c)
  if !a.positive? || !b.positive? || !c.positive?
    raise TriangleError, 'All sides should be positive'
  end

  raise TriangleError, 'Invalid sides values' unless valid_sides?(a, b, c)
  raise TriangleError, 'Invalid sides values' unless valid_sides?(a, c, b)
  raise TriangleError, 'Invalid sides values' unless valid_sides?(b, c, a)
end

def valid_sides?(side1, side2, side3)
  (side1 + side2) > side3
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
