# lets try to implement more efficient code


BLOCKS = %W(BO XK DQ CP NA GT RE FS JW HU VI LY ZF).freeze

def block_word?(word)
  word.upcase!
  BLOCKS.none? {|block| block.count(word) > 1 }
end
  

p block_word?('BATCH') == true
p block_word?('BUTCH') == false
p block_word?('jest') == true