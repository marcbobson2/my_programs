class ZeroBottles
  def verse(n)
    "No more bottles of beer on the wall, no more bottles of beer.\n" \
      "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
  end
end

class OneBottle
  def verse(n)
  "#{n} bottle of beer on the wall, #{n} bottle of beer.\n" \
      "Take it down and pass it around, no more bottles of beer on the wall.\n"
  end
end

class TwoBottles
  def verse(n)
      expected = "#{n} bottles of beer on the wall, #{n} bottles of beer.\n" \
      "Take one down and pass it around, #{n-1} bottle of beer on the wall.\n"
  end
end

class AllOtherBottles
  def verse(n)
    "#{n} bottles of beer on the wall, #{n} bottles of beer.\nTake one down and pass it around, #{n-1} bottles of beer on the wall.\n"
  end
end


class BeerSong
  LOOKUP = {0 => ZeroBottles, 1 => OneBottle, 2=> TwoBottles }
  LOOKUP.default = AllOtherBottles
  
  def verses(top, bottom=top)
    check_errors(top, bottom)
    final_verses = ""
    top.downto(bottom) { |verse_num| final_verses << verse(verse_num) + "\n" }
    final_verses.chomp
  end
  
  def verse(verse_num)
    check_errors(verse_num)
    final_verse = ""
    LOOKUP[verse_num].new.verse(verse_num)
  end
  
  def lyrics
    verses(99, 0)
  end
  
  def check_errors(top, bottom = top)
    raise RuntimeError, "Your starting number must be higher than your ending number!" if top < bottom
    raise RuntimeError, "You can't have any numbers > 99 or < 0!" if top > 99 || bottom > 99 || top < 0 || bottom < 0
  end
  
end





puts BeerSong.new.lyrics
