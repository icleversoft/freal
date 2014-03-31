class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :device
  belongs_to :station
end
