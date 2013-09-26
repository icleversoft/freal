class Municipality
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :code
  
  belongs_to :county
  has_many :cities, dependent: :destroy
  
  def city_codes
    self.cities.map{|city| city.code}
  end
  
  def url_for_fueltype( fuel_type = 1)
    "http://www.fuelprices.gr/CheckPrices?#{self.city_codes.collect{|i| "DD=#{i}"}.join('&')}&prodclass=#{fuel_type}"
  end
end
