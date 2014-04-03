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
  
  desc "Initialize Stations' Location"
  task :init_station_location => :environment do
    City.all.each do |c|
      next if c.municipality.nil?
      puts "Update for :#{c.name}..."
      c.municipality.stations.each do |s|
        s.update_attribute(:location, c.location)
      end
    end
  end
end
