class City
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  geocoded_by :location 
  reverse_geocoded_by :location
  
  # Searchkick.client.transport.logger = Logger.new("ES_City.log")
  searchkick locations: ["location"], merge_mappings: true, word_start: [:name], text_start: [:name], 
  settings: {
    analysis: {
      analyzer:{
        my_greek:{
          type: "custom",
          tokenizer: "standard",
          filter: ["lower_case_filter", "asciifolding", "searchkick_edge_ngram"],
          char_filter: [:greek_char_downcase]
        }
      },
      tokenizer:{
        my_tokenizer:{
          type: :standard,
          max_token_length: 900
        }
      },
      filter:{
        lower_case_filter:{
          type: :lowercase,
          language: :greek
        }
      },
      char_filter:{
        greek_char_downcase:{
          type: :mapping,
          mappings: GreekChars::GreekNormalizer.char_map
        }
      }
    }
  }, 
  mappings: {
    city: {
      properties:{
        name: {
          type: :string,
          analyzer: :my_greek
        }
      }
    }
  }
  
  # include Tire::Model::Search
  # include Tire::Model::Callbacks  
  # searchkick
  
  # acts_as_gmappable
  
  field :name
  field :code
  field :location, type: Array
  
  belongs_to :municipality
  
  
  
  
  # Tire.configure { logger 'elasticsearch.log' }
  # def to_indexed_json
  #   self.to_json(methods: :city_municipality)
  #   # to_json
  # end
  # 
  # mapping do
  #   indexes :location, type: :geo_point, geohash: true
  # end
  
  def search_data
    as_json#(method: city_municipality)
    # unless municipality.nil?
    #   attributes.merge municipality:  municipality.api_attributes
    # end
    # as_json 
    # attributes.merge location: [latitude, longitude]
  end
  #City.search "*", where: {location: {near: [37.96033, 23.71122], within: "4km"}}
  
  def self.nearby_city(lat, lon, distance = 1.5)
    cities = City.search "*", fields:[:name], where: {location: {near: [lat, lon], within: "#{distance}km"}}
    cities.first
  end
  
  
  def api_attributes
    data = {}
    attributes.select{|k,v| %w(_id name code).include?(k)}.each do |k, v|
      data[k] = v.to_s.strip
    end
    if municipality
      data['municipality'] = municipality.name
      data['county'] = municipality.county.name
    end
    data
  end
  
  def city_municipality
    if municipality.nil?
      return []
    else
      municipality.stations.collect{|i| i.api_attributes}
    end
  end
  
  def self.get_closest_cities( location )
    res = tire.search(per_page: 1) do
      query do
        all
      end
      filter "geo_distance", {:distance => "2000m", "location" => location, "distance_type" => "arc"}#[34.1445772, -118.4090847]
    end
    res
  end
  
end
