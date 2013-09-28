namespace :tools do
  desc "Clean all Price data"
  task :clean_prices => :environment do
    Price.destroy_all
  end  

  desc "Clean all Station data"
  task :clean_stations => :environment do
    Station.destroy_all
  end  
  
  desc "Clean all Owner data"
  task :clean_owner => :environment do
    Owner.destroy_all
  end  
  
  desc "Clean all"
  task :clean_all => :environment do
    Owner.destroy_all
    Station.destroy_all
  end  
end
