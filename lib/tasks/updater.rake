namespace :updater do
  desc "Import popular municipalities in topstat table"
  
  task :price => :environment do
    queue = Topstat.all.desc(:hits).map{|i| i.municipality}
    queue.each do |m|
      [1, 2, 4, 5, 6].each do |fuel_type|
        begin
          puts "Getting prices for codes:#{m.city_codes.join(',')}..."
          stations = Fuelprices::Parser.new(m.city_codes, fuel_type).stations
          # stations = Fuelprices::Parser.new(['A1030100'], 2).stations
          stations.each do |st|
            Price.insert_data_for_station( st )
          end
        rescue => e
          puts "An error occured :#{e.message}!"
        end
        #wait for 1sec
        sleep 1
      end
    end
  end  
end
