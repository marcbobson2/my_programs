class Triangle
  def initialize(row)
    @row = row
  end

  def rows
    pascal = [[1]]
    1.upto(@row - 1) do |row_count|
      pascal << generate_row([0] + pascal[row_count - 1] + [0])
    end
    pascal
  end

  def generate_row(padded_pascal)
    1.upto(padded_pascal.size - 1).each_with_object([]) do |index, temp_object|
      temp_object << padded_pascal[index] + padded_pascal[index - 1]
    end
  end
end

#p Triangle.new(5).rows
