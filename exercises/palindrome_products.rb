

class Palindromes
  attr_reader :largest, :smallest
  Palindrome = Struct.new(:value, :factors)

  def initialize(factor_hash)
    @max_factor = factor_hash[:max_factor]
    @min_factor = factor_hash[:min_factor] || 1
    @factor_combinations = Hash.new { |hash, key| hash[key] = [] }
    @palindrome = Palindrome.new
  end

  def generate

    (@min_factor..@max_factor).to_a.repeated_combination(2) do |x, y|
        @factor_combinations[x * y] << [x, y] if is_palindrome?(x, y)
    end
  end

  def is_palindrome?(x, y)
    (x * y).to_s == (x * y).to_s.reverse
  end

  def largest

    @factor_combinations.max[0]
    palindrome = Palindrome.new(@factor_combinations.max[0], @factor_combinations.max[1])
  end

  def extract_factors(products, factor_combinations, palindrome)
    palindrome_product_factors = []
    products.each_with_index do |product, index|
      palindrome_product_factors << factor_combinations[index] if product == palindrome
    end
    palindrome_product_factors
  end

end

palindromes = Palindromes.new(max_factor: 999, min_factor: 1)
palindromes.generate
largest = palindromes.largest
p largest.value
p largest.factors