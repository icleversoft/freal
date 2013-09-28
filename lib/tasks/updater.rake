namespace :updater do
  desc "Get prices for all popular municipalities"
  task :price => :environment do
    queue = Topstat.all.desc(:hits).map{|i| i.municipality}
    queue.each do |m|
      [1, 2, 4, 5, 6].each do |fuel_type|
          puts "Getting prices for codes:#{m.city_codes.join(',')}..."
          stations = Fuelprices::Parser.new(m.code, m.city_codes, fuel_type).stations
          stations.each do |st|
            Price.insert_data_for_station( st )
          end
        sleep 1
      end
    end
  end  
  
  desc "Get price for a specific municipality"
  task :price_for, [:code] => :environment do |t, args|
    if args.code.nil?
      puts "Specify a municipality code!"
      puts "i.e: rake updater:price_for[03620000]"
    else
      m = Municipality.where(:code => args.code).first
      if !m.nil?
        [1, 2, 4, 5, 6].each do |fuel_type|
            puts "Getting prices for codes:#{m.city_codes.join(',')}..."
            stations = Fuelprices::Parser.new(m.code, m.city_codes, fuel_type).stations
            stations.each do |st|
              Price.insert_data_for_station( st )
            end
        end
      else
        puts "Municipality not found!"
      end
    end
  end  
  
end
