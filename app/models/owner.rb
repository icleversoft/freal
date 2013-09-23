class Owner
  include Mongoid::Document
  include Mongoid::Timestamps
    
  field :name
  has_many :stations, :dependent => :destroy
end
