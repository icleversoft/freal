class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :run_on, :type => DateTime, :default => Time.now
  field :count, :type => Integer, :default => 0 
end
