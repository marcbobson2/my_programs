def rotate90(matrix)
  new_matrix = []
  0.upto((matrix[0].size) - 1) do |element_in_row|
    holder = []
    0.upto(matrix.size - 1) do |original_row|
      holder << matrix[original_row][element_in_row]
    end
    new_matrix << holder.reverse
  end
  new_matrix
end

def rotate_matrix(matrix, num_rotations)
  num_rotations.times do |_|
   matrix = rotate90(matrix)
  end
  matrix
end

matrix1 = [
  [1, 5, 8],
  [4, 7, 2],
  [3, 9, 6]
]


p rotate_matrix(matrix1, 4)

