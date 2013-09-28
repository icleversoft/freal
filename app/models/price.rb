class Price
  include Mongoid::Document
  include Mongoid::Timestamps

  before_create :set_slug
  field :price
  field :fuel_type, :type => Integer
  field :submitted
  field :slug
  
  index({ slug: 1 }, { unique: true, name: "slug_price_index" })
  
  belongs_to :station
  
  def self.insert_data_for_station( station )
    sl = "#{station.company.gr_normalize.gr_downcase}-#{station.submit_datetime.gr_normalize.gr_downcase}-#{station.fuel_type.gr_normalize.gr_downcase}"
    p sl
    pr = Price.where(:slug => sl).first
    return unless pr.nil?

    pr = Price.new(:price => station.price.to_f, :fuel_type =>station.ft, :submitted => station.submit_datetime)
    pr.station = Station.station_for_data( station )
    pr.save    
  end
  
  def set_slug
    self.slug = "#{self.station.firm.gr_normalize.gr_downcase}-#{self.submitted.gr_normalize.gr_downcase}-#{self.fuel_type}"
  end
  def fuel
    Station::FUEL_TYPES[self.fuel_type.to_s]
  end
end
