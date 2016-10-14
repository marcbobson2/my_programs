def transpose(matrix)
  new_matrix = []
    0.upto((matrix[0].size) - 1) do |element_in_row|
      holder = []
      0.upto(matrix.size - 1) do |original_row|
        holder << matrix[original_row][element_in_row]
    end
    new_matrix << holder
  end
  new_matrix
end


matrix = [
  [1, 5, 8],
  [4, 7, 2],
  [3, 9, 6]
]

new_matrix = transpose(matrix)


p new_matrix == [[1, 4, 3], [5, 7, 9], [8, 2, 6]]
p matrix == [[1, 5, 8], [4, 7, 2], [3, 9, 6]]