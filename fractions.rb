
def egyptian(fraction)
  result = []
  fraction.numerator == 1 ? denom = fraction.denominator + 1 : denom = 1
  
  loop do
    denom, fraction = next_fraction(fraction, denom)
    result << denom
    break if fraction == 0
    denom += 1
  end
  result
end

def unegyptian(arr)
  arr.inject(0) {|sum, n| sum + Rational(1, n) }
end


def next_fraction(fraction, denom)
  diff = 0
  loop do
    diff = fraction - Rational(1, denom)
    break if diff >= 0
    denom += 1
  end
  return denom, diff
end

p egyptian(Rational(2, 1))    # -> [1, 2, 3, 6]
p egyptian(Rational(137, 60)) # -> [1, 2, 3, 4, 5]
p egyptian(Rational(3, 1))    # -> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 230, 57960]
 
p unegyptian(egyptian(Rational(1, 2))) == Rational(1, 2)
p unegyptian(egyptian(Rational(3, 4))) == Rational(3, 4)
p unegyptian(egyptian(Rational(39, 20))) == Rational(39, 20)
p unegyptian(egyptian(Rational(127, 130))) == Rational(127, 130)
p unegyptian(egyptian(Rational(5, 7))) == Rational(5, 7)
p unegyptian(egyptian(Rational(1, 1))) == Rational(1, 1)
p unegyptian(egyptian(Rational(2, 1))) == Rational(2, 1)
p unegyptian(egyptian(Rational(3, 1))) == Rational(3, 1)
