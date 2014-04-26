namespace :updater do
  desc "Get prices for ALL  municipalities"
  task :all_prices => :environment do
    queue = Municipality.all
    ac = Activity.new
    
    count = 0
    queue.each do |m|
      puts "Getting prices for Municipality:#{m.name} -- #{m.code}..."
      [1, 2, 4, 5, 6].each do |fuel_type|
          begin
            puts "Getting prices for codes:#{m.city_codes.join(',')}..."
            stations = Fuelprices::Parser.new(m.code, m.city_codes, fuel_type).stations
            stations.each do |st|
              count = count + Price.insert_data_for_station( st, ac )
            end
          rescue => e
            puts "An error occured :#{e.message}"
          end
        sleep 1
      end
    end
    
    ac.count = count
    ac.save if count > 0
  end  
  
  desc "Get prices for all popular municipalities"
  task :price => :environment do
    queue = Topstat.all.desc(:hits).map{|i| i.municipality}
    ac = Activity.new
    
    count = 0
    # while queue.size > 0
    queue.each do |m|
      puts "Getting prices for Municipality:#{m.name} -- #{m.code}..."
      [1, 2, 4, 5].each do |fuel_type|
          begin
            # puts "Getting prices for codes:#{m.city_codes.join(',')}..."
            stations = Fuelprices::Parser.new(m.code, m.city_codes, fuel_type).stations
            unless stations.nil?
              stations.each do |st|
                count = count + Price.insert_data_for_station( st, ac )
                station = Station.station_for_data( st )
                station.tire.update_index unless station.nil?
              end
            end
          rescue => e
            puts "An error occured :#{e.message}"
          end
        sleep 2
      end
    end
    
    ac.count = count
    ac.save if count > 0
    Mailer.update_prices(count).deliver
  end  
  
  desc "Get price for a specific municipality"
  task :price_for, [:code] => :environment do |t, args|
    if args.code.nil?
      puts "Specify a municipality code!"
      puts "i.e: rake updater:price_for[03620000]"
    else
      m = Municipality.where(:code => args.code).first
      if !m.nil?
        [1, 2, 4, 5].each do |fuel_type|
            puts "Getting prices for codes:#{m.city_codes.join(',')}..."
            stations = Fuelprices::Parser.new(m.code, m.city_codes, fuel_type).stations
            unless stations.nil?
              stations.each do |st|
                Price.insert_data_for_station( st )
                station = Station.station_for_data( st )
                station.tire.update_index unless station.nil?
              end
            end
        end
      else
        puts "Municipality not found!"
      end
      Mailer.update_prices(count).deliver
    end
  end  
  
end
