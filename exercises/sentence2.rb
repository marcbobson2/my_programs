
class ProcessString
  def initialize(input_string)
    error_checks(input_string)
    @input_words = input_string.delete(".").strip
    @space_counter = 0
    @word_counter = 0
    @index = 0
    @end_state = false
  end
  
  def error_checks(input_string)
    raise RuntimeError, "This does not qualify as a sentence, it has the wrong number of periods." if input_string.count(".") != 1
    raise RuntimeError, "This word doesn't end in a period" if input_string[-1] != "."
    raise RuntimeError, "This sentence contains at least one word of more than 20 characters" if big_word(input_string)
    raise RuntimeError, "This string contains unapproved characters" if /[^A-z .]/.match(input_string)
    raise RuntimeError, "This string must contain at least one word" if !/[A-z]/.match(input_string)
  end
  
  def big_word(input_string)
    input_string.split(" ").any? { |word| word.size > 20 }
  end
  
  def process
    loop do
      @input_words[@index] == " " ? process_space : process_char
      break if end_of_string?(@index)
      @index += 1
    end
    print "."
    puts
  end
  
  def process_space
    @space_counter += 1 
    if @space_counter == 1
      print @input_words[@index]
      @word_counter += 1
    end
  end
  
  def process_char
    @space_counter = 0
    if @word_counter.even?
      print @input_words[@index]
    else
      end_index = find_end_index
      print_reverse_word(@index, end_index)
      @index = end_index
    end
  end
  
  def find_end_index
    end_index = @index
      loop do
        break if @input_words[end_index + 1] == " " || end_of_string?(end_index)
        end_index += 1
      end
    end_index
  end
  
  def print_reverse_word(start_index, end_index)
    end_index.downto(start_index) do |sub_index|
        print @input_words[sub_index]
    end
  end
  
  def end_of_string?(index)
    index == @input_words.size - 1
  end
end

ProcessString.new("hello word world  .").process

# rules
# if you are reading chars and hit a period, then just end
# if you start to read space, one of 2 conditions can occur:
# 2) you hit a period: you shouldn't print any spaces, just the period, and then EOF
# 3) you hit a character excluding period; you should print one space and then continue with char