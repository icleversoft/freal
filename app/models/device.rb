class Device
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_many :favorites, autosave: true, :dependent => :destroy
  
  field :token
  field :name
  field :dmodel
  field :version
  field :appVersion
  
  index({token: 1}, {unique: true})
end
