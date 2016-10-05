def featured(n)
   if n >= 9_876_543_201
       return "There is no next featured number"
   end
   feature_found = false
   while feature_found == false do
        n += 1
        if (n % 7 == 0) && (n.odd?)
            # now make sure it doesnt have any repeating #s
            num_str = n.to_s
            feature_found = num_str.chars.none? { |char| num_str.count(char) > 1 }
        end
   end
   n
end



p featured(12) == 21
p featured(20) == 21
p featured(21) == 35
#p featured(997) == 1029
#p featured(1029) == 1043
p featured(9_999_991_100)