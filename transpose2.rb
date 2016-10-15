def transpose_in_place(matrix)
  0.upto(matrix.size - 2) do |anchor|
    (anchor + 1).upto(matrix.size - 1) do |increment|
      matrix[increment][anchor], matrix[anchor][increment] = matrix[anchor][increment], matrix[increment][anchor] 
    end
  end
  matrix
  
  
end

matrix = [
  [1, 5, 9, 8],
  [2, 6, 2, 6],
  [3, 4, 3, 4],
  [4, 3, 7, 2]
]

p transpose_in_place(matrix)