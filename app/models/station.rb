class Station
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  before_create :set_slug

  FUEL_TYPES = { "1" => "Unleaded", 
                 "2" => "Unleaded-100", 
                 "3" => "Super", 
                 "4" => "Diesel", 
                 "5" => "Diesel Heat", 
                 "6" => "Gas"}

  field :address
  field :location, type: Array
  field :firm
  
  belongs_to :city
  has_one :owner, :dependent => :nullify, :inverse_of => nil
  has_many :prices, :dependent => :destroy
  
  def set_slug
    self.slug = "#{self.address.gr_normalize.gr_downcase}-#{self.firm.gr_normalize.gr_downcase}"
  end
  
  def self.station_for_data( station_data )
    sl = "#{station_data.address.gr_normalize.gr_downcase}-#{station_data.firm.gr_normalize.gr_downcase}"
    p sl
    st = Station.where(:slug => sl).first
    if st.nil?
      st = Station.create!(:address => station_data.address, :owner => Owner.find_or_create( station_data.company ))
    end
    st
  end
end
