class RunLengthEncoding

  def self.encode(input)
    encode_array(input).join
  end

  def self.decode(input)
    grouped_letters_numbers = split_out_letters(input.scan(/\d+|\D+/))
    get_decoded_result(grouped_letters_numbers)
  end

  private

  def self.get_decoded_result(grouped_letters_numbers)
    result = ""
    while grouped_letters_numbers.size != 0 do
      val1 = grouped_letters_numbers.slice!(0)
      val1 =~ /\d/ ? result << grouped_letters_numbers.slice!(0) * val1.to_i : result << val1
    end
    result
  end

  def self.split_out_letters(ungrouped_letters_numbers)
    ungrouped_letters_numbers.map! { |element| element[0] =~ /\D/ && element.size > 1 ? element.split("") : element }.flatten
  end

  def self.partially_encode_array(input)
    partially_encoded_array = []
    while input != "" do
      partially_encoded_array << input.slice!(/#{input[0]}+/)
    end
     partially_encoded_array
  end

  def self.encode_array(input)
    partially_encode_array(input).map do |element|
      element.size == 1 ? element[0] : element.size.to_s + element[0]
    end
  end
end

input = '3z 2Z2 zZ'
#p RunLengthEncoding.encode(input)

p RunLengthEncoding.decode(input)