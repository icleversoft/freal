namespace :updater do
  desc "Get prices for ALL  municipalities"
  task :all_prices => :environment do
    queue = Municipality.all
    ac = Activity.new
    
    count = 0
    while queue.size > 0
      m = queue.first
      [1, 2, 4, 5, 6].each do |fuel_type|
          begin
            puts "Getting prices for codes:#{m.city_codes.join(',')}..."
            stations = Fuelprices::Parser.new(m.code, m.city_codes, fuel_type).stations
            stations.each do |st|
              count = count + Price.insert_data_for_station( st, ac )
            end
            queue.delete_at(0)
          rescue => e
            puts "An error occured :#{e.message}"
            puts "Retrying..."
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
    while queue.size > 0
      m = queue.first
      [1, 2, 4, 5, 6].each do |fuel_type|
          begin
            puts "Getting prices for codes:#{m.city_codes.join(',')}..."
            stations = Fuelprices::Parser.new(m.code, m.city_codes, fuel_type).stations
            if stations.nil?
              queue << m 
            else
              stations.each do |st|
                count = count + Price.insert_data_for_station( st, ac )
              end
              queue.delete_at(0)
            end
          rescue => e
            queue << m 
            puts "An error occured :#{e.message}"
            puts "Retrying..."
          end
        sleep 1
      end
    end
    
    ac.count = count
    ac.save if count > 0
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
            stations = nil
            while stations.nil?
              stations = Fuelprices::Parser.new(m.code, m.city_codes, fuel_type).stations
              if stations.nil?
                puts "Timeout retry after 2secs..."
                sleep 2
              else
                stations.each do |st|
                  Price.insert_data_for_station( st )
                end
              end
            end
        end
      else
        puts "Municipality not found!"
      end
    end
  end  
  
end
