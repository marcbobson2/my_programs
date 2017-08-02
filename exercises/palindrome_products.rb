class Palindrome
  def initialize
    @value = nil
  end

  def value
    @value
  end

  def value=(pal)
    @value = pal
  end

  def factors
    @factors
  end

  def factors=(list_of_factors)
    @factors = list_of_factors
  end
end

class Largest < Palindrome
end

class Smallest < Palindrome
end


class Palindromes
  attr_reader :largest, :smallest

  def initialize(factor_hash)
    @max_factor = factor_hash[:max_factor]
    factor_hash[:min_factor] != nil ? @min_factor = factor_hash[:min_factor] : @min_factor = 1
    @largest = Largest.new
    @smallest = Smallest.new
  end

  def generate
    factor_combinations = (@min_factor..@max_factor).to_a.repeated_combination(2).to_a
    products = factor_combinations.map { |factors| (factors[0] * factors[1]).to_s }
    palindrome_products = products.select { |product| product == product.reverse }.uniq.map(&:to_i)
    @largest.value = palindrome_products.max
    @largest.factors = extract_factors(products, factor_combinations, @largest.value.to_s)
    @smallest.value = palindrome_products.min
    @smallest.factors = extract_factors(products, factor_combinations, @smallest.value.to_s)
  end

  def extract_factors(products, factor_combinations, palindrome)
    palindrome_product_factors = []
    products.each_with_index do |product, index|
      palindrome_product_factors << factor_combinations[index] if product == palindrome
    end
    palindrome_product_factors
  end

end

