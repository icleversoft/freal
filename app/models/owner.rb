class Owner
  include Mongoid::Document
  include Mongoid::Timestamps
  before_create :set_slug
    
  field :name
  field :slug
  has_many :stations, :class_name => 'Station', :dependent => :destroy, :foreign_key => 'station_id'
  index({ slug: 1 }, { unique: true, name: "slug_owner_index" })
  
  def set_slug
    self.slug = self.name.gr_normalize.gr_downcase
  end
  
  def self.find_or_create( name )
    sl = name.gr_normalize.gr_downcase
    ow = Owner.where(:slug => sl).first
    if ow.nil?
      ow = Owner.create!(:name => name)
    end
    ow
  end
  
end
