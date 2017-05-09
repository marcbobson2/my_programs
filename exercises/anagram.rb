class Anagram
  
  def initialize(base_word)
    @base_word = base_word
  end
    
  def match(candidate_words)
    candidate_words.select { |candidate_word| is_anagram?(@base_word, candidate_word) }
  end  
 
  
  def is_anagram?(base_word, candidate_word)
    return false if base_word.downcase == candidate_word.downcase
    freq_hash(base_word) == freq_hash(candidate_word)
  end
  
  def freq_hash(word)
    word_hash = Hash.new
    word.downcase.chars.each do |char|
      if word_hash.has_key?(char)
        word_hash[char] += 1
      else
        word_hash[char] = 1
      end
    end
    word_hash
  end
  
end

x = Anagram.new("listen")
p x.match(%w(enlists google inlets banana))
