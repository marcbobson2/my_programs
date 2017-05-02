# handle lower and upper case same way


class Hex
  attr_reader :hex
  VALID_HEX = /^[0-9A-F]+$/i
  HEX_VALUES = {'A' => "10", 'B' => "11", 'C' => "12", 'D' => "13", 'E' => "14", 'F' => "15" } 
  
  def initialize(hex)
    @hex = hex
  end
  
  def to_decimal
    return 0 if @hex !~ VALID_HEX
    convert_array.reverse.each_with_index.map { |number, index| number * (16 ** index) }.reduce(:+)
  end
  
  def convert_array
    hex.chars.map { |element| HEX_VALUES.fetch(element.upcase, element) }.map(&:to_i)
  end


end

p Hex.new("1e42").to_decimal