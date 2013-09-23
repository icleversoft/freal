class Station
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  FUEL_TYPES = (1..6).to_a
  #1:Unleaded, 2:Unleaded-100 3:Super 4:Diesel 5:Diesel-Heat 6:Gas

  field :name
  field :address
  field :location, type: Array
  field :firm
  
  belongs_to :city
  has_one :owner, :dependent => :nullify
  has_many :prices, :dependent => :destroy
end
