class County
  include Mongoid::Document
  include Mongoid::Timestamps
  paginates_per 10
  AREA_CODES = {'1' => 'Attica', '2' => 'Thessaloniki', '3' => 'Other Greece'}
  field :name
  field :code
  field :area, :type => Integer, :default => 0
  has_many :municipalities, dependent: :delete
  
  def api_attributes
    data = {}
    attributes.select{|k,v| %w(_id name code area).include?(k)}.each do |k, v|
      data[k] = v.to_s.strip
    end
    data
  end
end
