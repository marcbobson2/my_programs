class House

  def self.recite
    new.recite
  end

  def recite
    result = []
    1.upto(pieces.size) do |phrases|
      result << create_paragraph(pieces.last(phrases)) + "."
    end
    result.join("\n\n") + "\n"
  end

  def create_paragraph(phrases)
    result = "This is "
    phrases.each do |element|
      result += element[0]
      result += "\n" + element[1] + " " if element[1]
    end
    result
  end

  private

  def pieces
    [
      ['the horse and the hound and the horn', 'that belonged to'],
      ['the farmer sowing his corn', 'that kept'],
      ['the rooster that crowed in the morn', 'that woke'],
      ['the priest all shaven and shorn', 'that married'],
      ['the man all tattered and torn', 'that kissed'],
      ['the maiden all forlorn', 'that milked'],
      ['the cow with the crumpled horn', 'that tossed'],
      ['the dog', 'that worried'],
      ['the cat', 'that killed'],
      ['the rat', 'that ate'],
      ['the malt', 'that lay in'],
      ['the house that Jack built']
    ]
  end
end

#house = House.new
#p house.recite