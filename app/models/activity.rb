class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :run_on, :type => DateTime, :default => Time.now
  field :count, :type => Integer, :default => 0 
  has_many :prices, :dependent => :destroy, :foreign_key => 'activity_id'
end
