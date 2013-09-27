class Topstat
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :hits, type: Integer, :default => 0
  belongs_to :municipality
end
