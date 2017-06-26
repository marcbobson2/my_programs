VOWELS = ['a', 'e', 'i', 'o', 'u']

class PigLatin
  def initialize(word)
    @words = word.downcase.split
  end
  
  def convert_to_pig_latin
    @words.map do |word|
      starts_with_vowel_sound?(word) ? word.concat("ay") : treat_consonant(word)
    end
    @words.join(" ")
  end
  
  def starts_with_vowel_sound?(word)
    VOWELS.include?(word[0]) || has_vowel_sounding_consonant?(word)
  end
  
  def has_vowel_sounding_consonant?(word)
    word.match(/\A[x|y][^aeiou]+/)
  end
  
  def treat_consonant(word)
    word.concat(word[0..number_of_starting_consonants(word)] + "ay").slice!(0..number_of_starting_consonants(word))
    word
  end
  
  def number_of_starting_consonants(word)
    word.match(/\A([^aeiou]*qu|[^aeiou]+)/)[0].size - 1
  end
  
  def has_non_alpha?
    @words.any?  { |word| /[^A-z]/.match(word) }
  end
  
  def self.translate(phrase)
    return "You passed in a non-string item!" if phrase.class != String
    return "empty string" if phrase.empty?
    piggy = self.new(phrase)
    return "Your string can only contain letters!" if piggy.has_non_alpha?
    result = piggy.convert_to_pig_latin
    result
  end
end

p PigLatin.translate("queen")
  