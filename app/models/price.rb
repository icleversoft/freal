class Price
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  def to_indexed_json
    self.to_json
  end
  
  before_create :set_slug
  field :price, type: Float
  field :fuel_type, :type => Integer
  field :submitted
  field :slug
  field :fuel_description
  
  index({ slug: 1 }, { unique: true, name: "slug_price_index" })
  
  belongs_to :station
  belongs_to :activity
  
  def self.insert_data_for_station( station, activity = nil )
    return 0 if station.price.to_f == 0
      
    sl = "#{station.code.gr_normalize.gr_downcase}-#{station.company.gr_normalize.gr_downcase}-#{station.firm.gr_normalize.gr_downcase}-#{station.submit_datetime.gr_normalize.gr_downcase}-#{station.ft}"
    p sl
    pr = Price.where(:slug => sl).first
    return 0 unless pr.nil?

    pr = Price.new(:price => station.price.to_f, :fuel_type =>station.ft, :submitted => station.submit_datetime, :fuel_description => station.fuel_type)
    pr.station = Station.station_for_data( station )
    activity = Activity.last if activity.nil?
    pr.activity = activity
    pr.save  
    pr.tire.update_index
    return 1  
  end
  

  def set_slug
    self.slug = "#{self.station.city.code.gr_normalize.gr_downcase}-#{self.station.owner.name.gr_normalize.gr_downcase}-#{self.station.firm.gr_normalize.gr_downcase}-#{self.submitted.gr_normalize.gr_downcase}-#{self.fuel_type}"
  end
  def fuel
    Station::FUEL_TYPES[self.fuel_type.to_s]
  end

  def api_attributes
    data = {}
    attributes.keys.select{|i| %w(_id fuel_type price submitted fuel_description).include?(i)}.each do |k|
      data[k] = attributes[k]
    end
    data["activity_id"] = activity._id unless activity.nil?
    data
  end
  
end
