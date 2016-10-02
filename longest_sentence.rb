FILENAME = "book_to_scan.txt"



full_string = ""
File.foreach(FILENAME) { |x| full_string << x }
sentences = full_string.split(/(?<=[.?!])\s*/)
max_sentence = sentences.max_by {|sentence| sentence.split.size }
puts "The longest sentence contains #{max_sentence.split.size} words."
puts "The longest sentence reads: #{max_sentence}"




