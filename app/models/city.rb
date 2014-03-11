class City
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  
  include Tire::Model::Search
  include Tire::Model::Callbacks  
  # acts_as_gmappable
  
  field :name
  field :code
  field :location, type: Array
  
  belongs_to :municipality
  Tire.configure { logger 'elasticsearch.log' }
  def to_indexed_json
    to_json
  end
  
  mapping do
    indexes :location, type: :geo_point, geohash: true
  end
  
  def self.get_closest_cities( location )
    res = tire.search do
      query do
        all
      end
      filter "geo_distance", {:distance => "2000m", "location" => location}#[34.1445772, -118.4090847]
    end
    res
  end
  
end
