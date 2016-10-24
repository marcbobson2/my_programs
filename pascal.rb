# k is num rows


def pascal(num_rows, col_pos)
  
  return 0 if col_pos < 0 || col_pos >= num_rows
  return 1 if num_rows == 1
  
  sum = 0
  
    sum += pascal(num_rows - 1, col_pos) + pascal(num_rows - 1, col_pos - 1)

   sum
end

def control(num_rows)
  total = 0
  num_rows.downto(1) do |n_rows|
    0.upto(n_rows - 1) do |r|
      print pascal(n_rows, r)
      print " "
    end
    print "\n"
  end
  total
end


control(15)

