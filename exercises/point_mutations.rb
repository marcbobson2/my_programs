
class DNA
  VALID_ACIDS = ['a', 't', 'c', 'g'].freeze
  
  def initialize(strand1)
    @strand1 = strand1.downcase
  end
  
  def hamming_distance(strand2)
    diffs = @strand1.chars.zip(strand2.downcase.chars).reject do |pair| 
      pair[0] == pair[1] || pair.include?(nil)
    end
    diffs.count
  end
end
  
  p strand = DNA.new("agt").hamming_distance("agct")
  