# Approach
# 1. Normalize string: regex
# 2. Store as ??? (probably ARRAY)
# 3. Break into rows



class Crypto
  attr_reader :input, :size

  def initialize(input)
    @input = input
    @normalized_input = normalize_plaintext
  end

  def normalize_plaintext
    @input.downcase.scan(/\w/).join
  end

  def size
    Math.sqrt(@normalized_input.size).ceil # number of cols
  end

  def plaintext_segments
    @normalized_input.split("").each_slice(size).map(&:join)
  end

  def ciphertext
    raw_ciphertext.join
  end

  def normalize_ciphertext
    raw_ciphertext.join(" ")
  end

  private

  def raw_ciphertext
    result = Array.new(size) { |i| "" }
    plaintext_segments.each do |element|
      element.split("").each_with_index { |char, index| result[index] << char }
    end
    result
  end

end

x = Crypto.new("Madness, and then illumination.").normalize_ciphertext
p x


