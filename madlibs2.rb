FILENAME = "simple_story.txt"

WORDS = {
        noun: ["car", "boat", "person", "eyeball", "bush"], 
        adj: ["smooth", "hard", "soft", "red", "angry", "hungry", "wild", "tired", "chunky", "bulbous"],
        verb: ["run", "choke", "swim", "jump", "squeeze", "slurp"],
        adverb: ["slowly", "quickly", "hauntingly", "effortlessly", "daringly", "fearlessly"] 
        }.freeze
        
def read_file()
  full_string = ""
  File.foreach(FILENAME) { |x| full_string << x }
  full_string
end

def modify_story(full_string)
  arr = full_string.split(/\b/)
  arr.map! do |word|
    if WORDS.has_key?(word.to_sym)
     WORDS[word.to_sym].sample
    else
     word
    end
  end
  arr.join
  
end


full_string = read_file()
print modify_story(full_string)