class Device
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :token
  field :name
  field :dmodel
  field :version
  field :appVersion
  
  index({token: 1}, {unique: true})
end
