class Municipality
  include Mongoid::Document
  include Mongoid::Timestamps

  include Tire::Model::Search
  include Tire::Model::Callbacks  

  
  field :name
  field :code
  
  belongs_to :county
  has_many :cities, :dependent => :destroy
  has_one :topstat, :dependent => :destroy
  has_many :stations, :class_name => 'Station', :dependent => :destroy, :foreign_key => 'city_id'

  def to_indexed_json
    self.to_json(methods: :city_stations)
  end

  def city_stations
    stations
  end

  def api_attributes
    data = {}
    attributes.keys.select{|i| %w(_id name code).include?(i)}.each do |k|
      data[k] = attributes[k]
    end
    data
  end

  def city_codes
    self.cities.map{|city| city.code}
  end
  
  def url_for_fueltype( fuel_type = 1)
    "http://www.fuelprices.gr/CheckPrices?#{self.city_codes.collect{|i| "DD=#{i}"}.join('&')}&prodclass=#{fuel_type}"
  end
end
