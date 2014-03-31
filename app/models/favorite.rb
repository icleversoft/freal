class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :fuel_type, type: Integer
  
  belongs_to :device
  belongs_to :station
end
