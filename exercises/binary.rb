class SecretHandshake
  HANDSHAKES = ["wink", "double blink", "close your eyes", "jump"]

  def initialize(input)
    @input = input 
  end
  
  def commands
    @input.class == Fixnum ? binary_arr = convert_to_binary_string : binary_arr = convert_to_array
    determine_handshake(binary_arr)
  end
  
  def convert_to_array
    @input = "0" if @input =~ /[^0-1]/
    @input.split("").map(&:to_i).reverse
  end
  
  def determine_handshake(binary_array)
    chosen_handshakes = []
    binary_array.each_with_index do |element, index|
      chosen_handshakes << HANDSHAKES[index] if element == 1
    end
    chosen_handshakes.include?(nil) ? chosen_handshakes.compact.reverse : chosen_handshakes
  end
  
  def convert_to_binary_string
    binary_string = ""
    remaining_decimal = @input
    exponent = get_max_exponent
    
    loop do
      if remaining_decimal < 2 ** exponent then
       binary_string << "0"
      else
       binary_string << "1"
       remaining_decimal -= 2 ** exponent
      end
      exponent -= 1
      break if exponent == -1
    end
    convert_to_array(binary_string)
  end
  
  def get_max_exponent
    exponent = 0
    loop do
      break if (2**exponent) > @input
      exponent += 1
    end
    exponent - 1
  end
end




p SecretHandshake.new("1010").commands


