class PhoneNumber
  attr_reader :numeric_string
  INVALID = '0000000000'

  def initialize(user_input)
    @user_input = user_input
    @numeric_string = user_input.scan(/\d/).join
    @numeric_string.slice!(0) if valid_11_chars?
  end

  def number
    return INVALID if @user_input.match(/[A-Za-z]/)
    numeric_string.size == 10 ? numeric_string : INVALID
  end

  def area_code
    numeric_string[0..2]
  end

  def to_s
    "(" + numeric_string[0..2] + ") " + numeric_string[3..5] + "-" + numeric_string[6..9]
  end

  private

  def valid_11_chars?
    @numeric_string.size == 11 && @numeric_string[0] == '1'
  end
end