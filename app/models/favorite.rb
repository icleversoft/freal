class Favorite
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :fuel_type, type: Integer
  field :current_price, type: Float, default: 0.0
  
  belongs_to :device
  belongs_to :station
end
