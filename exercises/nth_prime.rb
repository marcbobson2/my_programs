class Prime

  def self.nth(nth_prime)
    raise ArgumentError, "Can't check a zero" if nth_prime == 0
    prime_storage = [2]
    num = 3
    last_prime_number = 1
    while prime_storage.size < nth_prime do
      prime_storage << num if is_prime?(num, prime_storage)
      num += 2
    end
    prime_storage[-1]
  end

  def self.is_prime2?(num, prime_storage)
    sqrt_of_num = Math.sqrt(num).to_i
    prime_storage.select { |stored_prime_number|
                        stored_prime_number <= sqrt_of_num && num % stored_prime_number == 0 }.size == 0
  end

  def self.is_prime?(num, prime_storage)
    sqrt_of_num = Math.sqrt(num).to_i
    index = 0
    until prime_storage[index] > sqrt_of_num
      return false if num % prime_storage[index] == 0
      index += 1
    end
    true
  end
end

#x = Prime.nth(1_000_000)
#puts "result is #{x}"