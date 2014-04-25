class Station
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  
  include Tire::Model::Search
  include Tire::Model::Callbacks  

  
  before_create :set_slug
  after_update :notify_devices
  
  FUEL_TYPES = { "1" => "Unleaded-95", 
                 "2" => "Unleaded-100", 
                 "3" => "Super", 
                 "4" => "Diesel", 
                 "5" => "Diesel Heat", 
                 "6" => "Gas"}

  field :address
  field :location, type: Array
  field :firm
  field :slug 
  
  belongs_to :city, :class_name => 'Municipality', :foreign_key => 'city_id'
  belongs_to :owner, :class_name => 'Owner', :dependent => :nullify, :foreign_key => 'station_id'
  has_many :prices, :dependent => :destroy

  has_many :favorites, autosave: true, :dependent => :destroy
  # belongs_to :favorite

  # Tire.configure { logger 'station_es.log' }
    
  def station_prices
    self.prices
  end

  mapping do
    indexes :location, type: :geo_point, geohash: true
  end

  def to_indexed_json
    self.to_json(methods: [:station_prices, :api_attributes])
  end
  
  index({ slug: 1 }, { unique: true, name: "slug_station_index" })
  
  def set_slug
    a1 = self.address.gr_normalize.gr_downcase unless self.address.nil?
    a2 = self.firm.gr_normalize.gr_downcase unless self.firm.nil?
    self.slug = "#{self.city.code.gr_normalize.gr_downcase}-#{a1}-#{a2}"
  end

  def self.get_closest_stations( location )
    res = tire.search(:per_page => 50, :page => 1) do
      query do
        all
      end
      filter "geo_distance", {:distance => "5000m", "location" => location, "distance_type" => "arc"}#[34.1445772, -118.4090847]
    end
    res
  end
  
  def self.station_for_data( station_data )
    sl = "#{station_data.code.gr_normalize.gr_downcase}-#{station_data.address.gr_normalize.gr_downcase}-#{station_data.firm.gr_normalize.gr_downcase}"
    st = Station.where(:slug => sl).first
    st.touch unless st.nil?
    if st.nil?
      ct = Municipality.where(:code => station_data.code).first
      st = Station.create!(:address => station_data.address, :owner => Owner.find_or_create( station_data.company ), :firm => station_data.firm, :city => ct)
    end
    st
  end
  
  def api_attributes
    data = {}
    # attributes.keys.select{|i| %w(_id firm address).include?(i)}.each do |k|
    #   data[k] = attributes[k]
    # end
    data["_id"] = _id
    data["firm"] = firm
    data["address"] = address
    data["prices"] = prices.where(fuel_type:1).desc(:created_at).limit(1).map{|i| i.api_attributes }
    data
  end
  
  def notify_devices
    price_entry = prices.where(:fuel_type=>1).last
    unless price_entry.nil?
      price_value = price_entry.price
      submitted = price_entry.submitted


      favorites.each do |fav|
        notify = Icapnd::Notification.new
        notify.token = fav.device.token
        notify.alert = "#{address}: #{price_value} / #{submitted}"
        notify.sound = "default.aiff"
        notify.push  
      end
    end
    
  end
  
end
