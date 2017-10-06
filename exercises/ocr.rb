class OCR
  attr_reader :nums

  NUM_GRIDS = [" _\n| |\n|_|\n", "\n  |\n  |\n", " _\n _|\n|_\n",
            " _\n _|\n _|\n", "\n|_|\n  |\n", " _\n|_\n _|\n",
            " _\n|_\n|_|\n", " _\n  |\n  |\n", " _\n|_|\n|_|\n",
            " _\n|_|\n _|\n"
            ]

  def initialize(input)
    @input = input
  end

  def convert
    final_num_str = ""
    num_rows = @input.split("\n\n").size
    @input.split("\n\n").each do |element|
      numbers_split_by_row = split_input_by_rows(element)
      isolated_numbers = create_number_array(numbers_split_by_row)
      final_num_str += read_number_array(isolated_numbers)
    end
    num_rows > 1 ? add_commas(final_num_str) : final_num_str
  end

  private

  def read_number_array(isolated_numbers)
    num_string = ""
    isolated_numbers.each do |text_num|
      num_string += (NUM_GRIDS.find_index(text_num) || "?").to_s
    end
    num_string
  end

  def add_commas(num_string)
    num_string.chars.reverse.each_slice(3).map(&:join).join(",").reverse
  end

  def split_input_by_rows(input)
    input.split("\n")
  end

  def create_number_array(numbers_split_by_row)
    assembled_numbers = []
    count_of_numbers(numbers_split_by_row[0].size).times do |counter|
      starting_index = counter * 3
      ending_index = starting_index + 2
      assembled_numbers << numbers_split_by_row[0][starting_index..ending_index].rstrip + "\n" +
                numbers_split_by_row[1][starting_index..ending_index].rstrip + "\n" +
                numbers_split_by_row[2][starting_index..ending_index].rstrip + "\n"
    end
    assembled_numbers
  end

  def count_of_numbers(row_size)
    return 1 if row_size == 0
    row_size % 3 == 0 ? row_size / 3 : row_size / 3 + 1
  end
end


      text = <<-NUMBER.chomp
    _  _
  | _| _|
  ||_  _|

    _  _
|_||_ |_
  | _||_|

 _  _  _
  ||_||_|
  ||_| _|

NUMBER

puts OCR.new(text).convert

