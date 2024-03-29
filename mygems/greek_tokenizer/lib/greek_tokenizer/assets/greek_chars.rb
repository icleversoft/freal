#encoding: utf-8
module GreekChars
  GR_UPPERS = {
    "Α" => "α", "Β" => "β", "Γ" => "γ", "Δ" => "δ", "Ε" => "ε", "Ζ" => "ζ",
    "Η" => "η", "Θ" => "θ", "Ι" => "ι", "Κ" => "κ", "Λ" => "λ", "Μ" => "μ",
    "Ν" => "ν", "Ξ" => "ξ", "Ο" => "ο", "Π" => "π", "Ρ" => "ρ", "Σ" => "σ",
    "Τ" => "τ", "Υ" => "υ", "Φ" => "φ", "Χ" => "χ", "Ψ" => "ψ", "Ω" => "ω"    
  }
  
  GR_ALPHA = [
    "ἀ", "ἁ", "ἂ", "ἃ", "ἄ", "ἅ", "ἆ", "ἇ", 
    "Ἀ", "Ἁ", "Ἂ", "Ἃ", "Ἄ", "Ἅ", "Ἆ", "Ἇ",
    "ὰ", "ά", 
    "ᾀ", "ᾁ", "ᾂ", "ᾃ", "ᾄ", "ᾅ", "ᾆ", "ᾇ",
    "ᾈ", "ᾉ", "ᾊ", "ᾋ", "ᾌ", "ᾍ", "ᾎ", "ᾏ",
    "ᾰ", "ᾱ", "ᾲ", "ᾳ", "ᾴ", "ᾶ", "ᾷ",
    "Ᾰ", "Ᾱ", "Ὰ", "Ά", "ᾼ", "Ά"
  ]
  
  GR_EPSILON = [
    "ἐ", "ἑ", "ἒ", "ἓ", "ἔ", "ἕ",
    "Ἐ", "Ἑ", "Ἓ", "Ἔ", "Ἕ",
    "ὲ", "έ",
    "Ὲ", "Έ", "Έ"
  ]
  
  GR_IETHA = [
    "ἠ", "ἡ", "ἢ", "ἣ", "ἤ", "ἥ", "ἦ", "ἧ",
    "Ἠ", "Ἡ", "Ἢ", "Ἣ", "Ἤ", "Ἥ", "Ἦ", "Ἧ",
    "ὴ", "ή",
    "ᾐ", "ᾑ", "ᾒ", "ᾓ", "ᾔ", "ᾕ", "ᾖ", "ᾗ",
    "ᾘ", "ᾙ", "ᾚ", "ᾛ", "ᾜ", "ᾝ", "ᾞ", "ᾟ",
    "ῂ", "ῃ", "ῄ", "ῆ", "ῇ", 
    "Ὴ", "Ή", "ῌ", "Ή"
  ]
  
  GR_IOTA = [
    "ἰ", "ἱ", "ἲ", "ἳ", "ἴ", "ἵ", "ἶ", "ἷ",
    "Ἰ", "Ἱ", "Ἲ", "Ἳ", "Ἴ", "Ἵ", "Ἶ", "Ἷ",
    "ὶ", "ί",
    "ῐ", "ῑ", "ῒ", "ΐ", "ῖ", "ῗ", "ϊ",
    "Ῐ", "Ῑ", "Ὶ", "Ί", "Ϊ", "Ί"
  ]
  
  GR_OMICRON = [
    "ὀ", "ὁ", "ὂ", "ὃ", "ὄ", "ὅ",
    "Ὀ", "Ὁ", "Ὂ", "Ὃ", "Ὄ", "Ὅ",
    "ὸ", "ό", 
    "Ό"
  ]
  
  GR_YPSILON = [
    "ὐ", "ὑ", "ὒ", "ὓ", "ὔ", "ὕ", "ὖ", "ὗ",
    "Ὑ", "Ὓ", "Ὕ", "Ὗ",
    "ὺ", "ύ",
    "ῠ", "ῡ", "ῢ", "ΰ", "ῦ", "ῧ",
    "Ῠ", "Ῡ", "Ὺ", "Ύ", "Ϋ", "Ύ"
  ]
  
  GR_RHO = [
    "ῤ", "ῥ",
    "Ῥ"
  ]

  GR_SIGMA = [ "ς" ]
  
  GR_OMEGA = [
    "ὠ", "ὡ", "ὢ", "ὣ", "ὤ", "ὥ", "ὦ", "ὧ",
    "Ὠ", "Ὡ", "Ὢ", "Ὣ", "Ὤ", "Ὥ", "Ὦ", "Ὧ",
    "ὼ", "ώ",
    "ᾠ", "ᾡ", "ᾢ", "ᾣ", "ᾤ", "ᾥ", "ᾦ", "ᾧ",
    "ᾨ", "ᾩ", "ᾪ", "ᾫ", "ᾬ", "ᾭ", "ᾮ", "ᾯ",
    "ῲ", "ῳ", "ῴ", "ῶ", "ῷ",
    "Ὼ", "Ώ", "ῼ"
  ]
  class GreekNormalizer
    attr_reader :downcase
    def initialize
      return unless defined?(@@gr_downcase).nil?
      build_downcase     
    end
    
    def self.char_map
      GreekNormalizer.new.downcase.to_a.collect{|i| "#{i[0]}=>#{i[1]}"}
    end
    
    def downcase
      return @@gr_downcase 
    end
    
    def build_downcase
      @@gr_downcase = {}
      @@gr_downcase.merge!( GR_UPPERS )
      GR_ALPHA.each {|c| @@gr_downcase[c] = 'α'}
      GR_EPSILON.each {|c| @@gr_downcase[c] = 'ε'}
      GR_IETHA.each {|c| @@gr_downcase[c] = 'η'}
      GR_IOTA.each {|c| @@gr_downcase[c] = 'ι'}
      GR_OMICRON.each {|c| @@gr_downcase[c] = 'ο'}
      GR_YPSILON.each {|c| @@gr_downcase[c] = 'υ'}
      GR_RHO.each {|c| @@gr_downcase[c] = 'ρ'}
      GR_OMEGA.each {|c| @@gr_downcase[c] = 'ω'}
      GR_SIGMA.each {|c| @@gr_downcase[c] = 'σ'}
    end
  end
end