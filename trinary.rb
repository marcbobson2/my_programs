class Trinary
  attr_reader :trinary
  INVALID_TRINARY = /\D|[3-9]/
  
  def initialize(trinary)
    @trinary = trinary
  end
  
  def to_decimal
    return 0 if @trinary =~ INVALID_TRINARY
    @trinary.chars.reverse.each_with_index.map { |char, index| char.to_i * (3 ** index) }.reduce(:+)
  end


end

p Trinary.new("1000").to_decimal