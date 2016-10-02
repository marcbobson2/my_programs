
          
def block_word?(word)
  block_pairs = "BOXKDQCPNAGTREFSJWHUVILYZM"
  word.upcase.chars.each do |letter|
    index = block_pairs.index(letter)
    if index
      index.even? ? pairing = 1 : pairing = -1
      item1, item2 = block_pairs[index], block_pairs[index + pairing] 
      block_pairs.delete! item1 + item2
    else
      return false
    end
  end
  true
end
         
         
    
p block_word?('BATCH') == true
p block_word?('BUTCH') == false
p block_word?('jest') == true
p block_word?('BATTCH') == false