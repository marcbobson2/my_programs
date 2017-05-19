# ignore (strip) punctuation
# handles cramped lists (e.g. "one,two,three")
# handles newline: "one,\ntwo,\nthree"
# numbers should be treated like words
# case insensitive: GO = go

# data structure: hash feels like the right choice, with key:value pairing

# happy path algorithm:
# split string by word (regex? split method?)
# iterate through the collection, modifying the hash as needed

# edge cases:
# punctuation: once the word is parsed out (punctuation and all), then strip the punctuation

class Phrase
  def initialize(word)
    @word_arr = word.downcase.scan(/[a-z0-9']+/)
    @word_arr.each { |word| word.gsub!(/^'|'$/,"") }
  end
  
  def word_count
    @word_arr.each_with_object(Hash.new(0)) { |word, freq_hash| freq_hash[word] += 1 }
  end
    
    
end

phrase = Phrase.new("hello world Hello to you to my 'friend' friend who i don't love you")
p phrase.word_count

