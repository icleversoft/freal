class Price
  include Mongoid::Document
  include Mongoid::Timestamps

  field :price
  field :fuel_type, :type Integer
  field :submitted, type: DateTime
  belongs_to :station
end
