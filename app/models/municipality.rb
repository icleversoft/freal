class Municipality
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :code
  
  belongs_to :county
  has_many :cities, dependent: :destroy
end
