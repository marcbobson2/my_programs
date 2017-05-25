  POS_HASH = { 1 => ["I", "V", "X"], 10 => ["X", "L", "C"], 100 => ["C", "D", "M"], 1000 => ["M", "M", "M"] }


class Fixnum

  def to_roman
  
    number = self
    positions = number.to_s.split("").map(&:to_i).reverse
    final_roman = []
    
    positions.each_with_index do |num, index|
       final_roman << determine_roman(10 ** index, num)
    end
    final_roman.reverse.join
  end
  
  def determine_roman(place, num)
    lower = POS_HASH[place][0]
    middle = POS_HASH[place][1]
    upper = POS_HASH[place][2]
    
    case num
    when 1..3
      lower * num
    when 4
      lower + middle
    when 5..8
      middle + lower * (num - 5)
    when 9
      lower + upper
    end
  end
end



#3000.to_roman
