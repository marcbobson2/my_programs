
def bubble_sort!(array)
  begin
    swaps = false
    0.upto(array.size - 2) do |index| 
     if array[index] > array[index + 1]
       array[index], array[index +1] = array[index + 1], array[index]
       swaps = true
     end
    end
  end until swaps == false
  array
end




array = [10, 9, 8, 7, 6, 5, 4,3, 2, 1]
bubble_sort!(array)
#array == [3, 5]

#array = [6, 2, 7, 1, 4]
#bubble_sort!(array)
#array == [1, 2, 4, 6, 7]

#array = %w(Sue Pete Alice Tyler Rachel Kim Bonnie)
#bubble_sort!(array)
#array == %w(Alice Bonnie Kim Pete Rachel Sue Tyler)