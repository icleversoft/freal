source 'https://rubygems.org'
ruby '1.9.3'
gem 'rails', '3.2.17'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem 'devise', '2.2.8'
gem 'figaro'
gem 'haml-rails'
gem 'mongoid'

gem 'capistrano'
gem 'rvm-capistrano'


gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

#Google Maps for rails
gem 'gmaps4rails'

gem 'geocoder' #https://github.com/alexreisner/geocoder
gem 'unicorn'

#--------------------
gem "i18n"
gem "hiredis"
gem "redis"
gem "em-synchrony"
gem 'yajl-ruby'
gem 'daemons'
gem 'icapnd', :path => 'mygems/icapnd'# :git => 'git@github.com:icleversoft/icapnd.git'
#--------------------


gem 'simple_form'
gem 'kaminari-bootstrap', '~> 0.1.3'
gem 'nokogiri'

gem 'fuelprices', :path => 'mygems/fuelprices'
gem 'greek_tokenizer', :path => 'mygems/greek_tokenizer'
gem 'whenever', :require => false
gem 'tire', :path => 'mygems/retire'
gem "searchkick", :path => 'mygems/searchkick' #~>0.6.3'


group :development do
  # gem 'logging-rails', :require => 'logging/rails'
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'html2haml'
  gem 'hub', :require=>nil
  gem 'quiet_assets'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'launchy'
  gem 'mongoid-rspec'
end
