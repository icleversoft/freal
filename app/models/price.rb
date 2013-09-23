class Price
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, type: Float
  field :submitted, type: DateTime
  belongs_to :station
end
