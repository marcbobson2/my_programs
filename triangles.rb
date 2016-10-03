
def is_valid?(s1, s2, s3)
  sides = []
  sides << s1 << s2 << s3
  return false if sides.include?(0)
 
  max_side = sides.max
  sides.delete_at(sides.index(sides.max))
  sides.reduce(:+) > max_side
end

def id_type(s1, s2, s3)
  return :equilateral if (s1 == s2) && (s1 == s3)
  return :scalene if (s1 != s2) && (s1 != s3) && (s2 != s3)
  :isosceles
end

def triangle(s1, s2, s3)
  if is_valid?(s1, s2, s3)
    id_type(s1,s2,s3)
  else
    :invalid
  end
  
end

p triangle(3, 3, 3) == :equilateral
p triangle(3, 3, 1.5) == :isosceles
p triangle(3, 4, 5) == :scalene
p triangle(0, 3, 3) == :invalid
p triangle(3, 1, 1) == :invalid