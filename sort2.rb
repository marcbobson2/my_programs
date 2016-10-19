
def merge(arr1, arr2)
  return arr2 if arr1.empty?
  return arr1 if arr2.empty?
  new_arr = []
  arr1_max = false
  arr2_max = false
  idx1 = 0
  idx2 = 0
  
  loop do
    arr1_max = TRUE if idx1 == arr1.size
    arr2_max = TRUE if idx2 == arr2.size
    return new_arr if arr1_max && arr2_max
    if arr1_max || arr2_max
      if arr1_max
        new_arr << arr2[idx2]
        idx2 += 1
      else
        new_arr << arr1[idx1]
        idx1 += 1
      end
    else
      if arr1[idx1] <= arr2[idx2]
        new_arr << arr1[idx1]
        idx1 += 1
      else
        new_arr << arr2[idx2]
        idx2 += 1
      end
    end
  end
end




p merge([1, 5, 9], [2, 6, 8]) == [1, 2, 5, 6, 8, 9]
#p merge([1, 1, 3], [2, 2]) == [1, 1, 2, 2, 3]
#p merge([], [1, 4, 5]) == [1, 4, 5]
#p merge([1, 4, 5], []) == [1, 4, 5]