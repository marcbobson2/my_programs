PAIR_GRAMMAR = [["(",")"],["[","]"],["{","}"]].freeze
NONPAIR_GRAMMAR = ["\"","\'"].freeze

def balanced_pairs?(string)
  PAIR_GRAMMAR.each do |pair|
    balanced = 0
    string.chars.each do |char|
      case char
        when pair[0] then balanced += 1
        when pair[1] then balanced -= 1
      end
      return false if balanced < 0
    end
    return false if !balanced.zero?
  end
  true
end

def single_marks?(string)
  NONPAIR_GRAMMAR.none? { |item| string.count(item) % 2 != 0 }
end

def balanced?(string)
  balanced_pairs?(string) && single_marks?(string)
end


p balanced?('{} [] "" \' \' \'  [] \'')
#p balanced?('What (is) {t}his?') == true
#p balanced?('What is) this?') == false
#p balanced?('What (is this?') == false
#p balanced?('((What) (is this))?') == true
#p balanced?('((What)) (is this))?') == false
#p balanced?('Hey!') == true
#p balanced?(')Hey!(') == false
#p balanced?('What ((is))) up(') == false