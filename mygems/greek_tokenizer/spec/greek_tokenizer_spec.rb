#encoding: UTF-8
require 'spec_helper'

describe "greek_tokenizer" do
  it "map file's mappings are valid" do
    map = String.new.gr_down_map
    map['Σ'].should == 'σ'
    map['Ε'].should == 'ε'
    map['Θ'].should == 'θ'
    
  end
  
  it "should downcase" do
    str = 'Πίνω'
    str.gr_downcase.should == 'πινω'
    
    str = 'Άσχημος' 
    str.gr_downcase.should == 'ασχημοσ'
  end
  
end