class City
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  
  # acts_as_gmappable
  
  field :name
  field :code
  field :location, type: Array
  
  belongs_to :municipality
  has_many :stations, :dependent => :destroy
end
