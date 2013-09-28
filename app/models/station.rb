class Station
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  before_create :set_slug

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
  
  index({ slug: 1 }, { unique: true, name: "slug_station_index" })
  
  def set_slug
    a1 = self.address.gr_normalize.gr_downcase unless self.address.nil?
    a2 = self.firm.gr_normalize.gr_downcase unless self.firm.nil?
    self.slug = "#{a1}-#{a2}"
  end
  
  def self.station_for_data( station_data )
    sl = "#{station_data.address.gr_normalize.gr_downcase}-#{station_data.firm.gr_normalize.gr_downcase}"
    st = Station.where(:slug => sl).first
    if st.nil?
      ct = Municipality.where(:code => station_data.code).first
      st = Station.create!(:address => station_data.address, :owner => Owner.find_or_create( station_data.company ), :firm => station_data.firm, :city => ct)
    end
    st
  end
end
