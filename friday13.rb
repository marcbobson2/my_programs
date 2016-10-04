require 'date'


def friday_13th?(year)
  counter = 0
  active_date = Date.new(year, 1, 13)
  
  friday13 = []
  
  1.upto(12) do |month|
    friday13 << month if active_date.friday?
    active_date = active_date >> 1
  end
    friday13.size
end



p friday_13th?(2015) == 3
p friday_13th?(1986) == 1