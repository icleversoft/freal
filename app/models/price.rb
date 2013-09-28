class Price
  include Mongoid::Document
  include Mongoid::Timestamps

  before_create :set_slug
  field :price
  field :fuel_type, :type => Integer
  field :submitted
  field :slug
  field :fuel_description
  
  index({ slug: 1 }, { unique: true, name: "slug_price_index" })
  
  belongs_to :station
  
  def self.insert_data_for_station( station )
    return 0 if station.price.to_f == 0
      
    sl = "#{station.code.gr_normalize.gr_downcase}-#{station.company.gr_normalize.gr_downcase}-#{station.firm.gr_normalize.gr_downcase}-#{station.submit_datetime.gr_normalize.gr_downcase}-#{station.ft}"
    p sl
    pr = Price.where(:slug => sl).first
    return 0 unless pr.nil?

    pr = Price.new(:price => station.price.to_f, :fuel_type =>station.ft, :submitted => station.submit_datetime, :fuel_description => station.fuel_type)
    pr.station = Station.station_for_data( station )
    pr.save  
    return 1  
  end
  
  def set_slug
    self.slug = "#{self.station.city.code.gr_normalize.gr_downcase}-#{self.station.owner.name.gr_normalize.gr_downcase}-#{self.station.firm.gr_normalize.gr_downcase}-#{self.submitted.gr_normalize.gr_downcase}-#{self.fuel_type}"
  end
  def fuel
    Station::FUEL_TYPES[self.fuel_type.to_s]
  end
end
