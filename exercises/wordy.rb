class WordProblem
  OPERATORS = {"plus" => "+", "minus" => "-", "divided" => "/", "multiplied" => "*" }

  def initialize(sentence)
    @sentence = sentence.chop
    @elements = clean(@sentence.split)
    validate
  end

  def clean(sentence_arr)
    sentence_arr.map! do |element|
      if OPERATORS.has_key?(element)
        OPERATORS[element]
      elsif element =~ /^-?\d+$/
        element.to_i
      else
        nil
      end
    end
    sentence_arr.compact!
  end

  def validate
    raise ArgumentError if @elements.size.even? # indicates there is no equation
    raise ArgumentError if @elements.size <= 1 # indicates there is only 1 item (can't process this)
    required_integers_in_array = (@elements.size / 2) + 1
    actual_integers_in_array = @elements.select {|element| element.class == Fixnum }.size
    raise ArgumentError if required_integers_in_array != actual_integers_in_array # makes sure you have pairs of #s to operate on
  end

  def answer
    while @elements.size > 1 do
      result = @elements[0].send(@elements[1], @elements[2])
      @elements.slice!(0..2)
      @elements.insert(0, result)
    end
      @elements[0]
  end
end

#p WordProblem.new('What is 1 plus 1?').answer