module Diamond
  def self.make_diamond(input)
    return (input + "\n") if input == "A"
    build_master(input)
    #puts print_row(input, 5)
    #puts print_row(input.succ, 4)
  end

  def self.build_master(input)
    result = []
    result = build_top(input)
    result.push(result[0..result.size - 2].reverse).flatten.join
  end

  def self.build_top(input)
    temp_result = []
    current_letter = "A"
    (input.ord - current_letter.ord + 1).times do |n|
      temp_result << print_row(n, current_letter, input)
      current_letter.succ!
    end
    temp_result
  end

  def self.print_row(row, current_letter, input_letter)
    padding = input_letter.ord - "A".ord - row
    if row == 0
      return " " * padding + current_letter + " " * padding + "\n"
    else
      left_side = (" " * padding) + current_letter
      center =  " " * ((row * 2) - 1)
      right_side = current_letter + (" " * padding)
      left_side + center + right_side + "\n"
   end
 end
end

#Diamond.make_diamond("F")

