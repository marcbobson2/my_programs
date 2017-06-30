class InvalidCodonError < RuntimeError
end

class Translation
  CODON_PROTEIN_MAPPING = { 
    "AUG" => "Methionine", "UUU" => "Phenylalanine", "UUC" => "Phenylalanine", "UUA" => "Leucine", "UUG" => "Leucine",
    "UCU" => "Serine", "UCC" => "Serine", "UCA" => "Serine", "UCG" => "Serine", "UAU" => "Tyrosine", "UAC" => "Tyrosine",
    "UGU" => "Cysteine", "UGC" => "Cysteine",  "UGG" => "Tryptophan", "UAA" => "STOP", "UAG" => "STOP", "UGA" => "STOP" }
  
  def self.of_codon(codon)
    CODON_PROTEIN_MAPPING.has_key?(codon) ? CODON_PROTEIN_MAPPING[codon] : "INVALID"
  end

  def self.of_rna(rna_strand)
    validate_rna_strand(rna_strand)
    proteins = generate_codons_from_rna_strand(rna_strand)
    proteins.include?("STOP") ? remove_post_stop_codons(proteins) : proteins
  end
  
  def self.generate_codons_from_rna_strand(rna_strand)
    proteins = rna_strand.scan(/.../).map { |codon| of_codon(codon) }
  end
  
  def self.remove_post_stop_codons(proteins)
    stop_location = proteins.index("STOP")
    proteins.slice(0, stop_location)
  end
  
  def self.validate_rna_strand(rna_strand)
    raise InvalidCodonError, "Not proper number of codons!" if rna_strand.size % 3 != 0
    raise InvalidCodonError, "Empty string" if rna_strand.empty?
    proteins = generate_codons_from_rna_strand(rna_strand)
    raise InvalidCodonError, "Non-valid codons detected!" if proteins.include?("INVALID")
  end
  
end

#p Translation.of_rna("UGGUGUUAUUAAUGGUUU")