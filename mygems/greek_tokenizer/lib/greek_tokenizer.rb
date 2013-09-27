require File.dirname(__FILE__) + '/greek_tokenizer/assets/greek_chars'

class String
  # include GreekChars
  attr_reader :gr_down_map
    
  def gr_downcase
    build_character_map
    string = self.downcase.strip
    new_string = ""
    string.each_char do |c|
      next if ["(", ")", "[", "]", "\""].include?(c)
      l = @@gr_map[c]
      if l.nil?
        new_string << c
      else
        new_string << l
      end  
    end 
    new_string
  end
  
  def gr_normalize
    self.strip.gsub(',', '').gsub('.', '').gsub(/\s+/, '_').gsub('/', '').gsub('\\', '')  
  end
  
  def gr_down_map
    build_character_map
    @@gr_map
  end
  
  def build_character_map
    return unless defined?(@@gr_map).nil?
    @@gr_map = {}
    gm = GreekChars::GreekNormalizer.new
    @@gr_map = gm.downcase
  end
  
end
