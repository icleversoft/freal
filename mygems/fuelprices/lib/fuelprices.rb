require "fuelprices/version"
require 'iconv'
#d=Nokogiri::HTML(open('http://www.fuelprices.gr/CheckPrices?DD=A1140100&prodclass=1'))
#entries = d.search("td[@class='mainArea']/table")
# if entries.size > 2
#   2.times do
#     entries.delete(entries.first)
#   end
# end
module Fuelprices
  BASE_URL = "http://www.fuelprices.gr/CheckPrices?"
  class Station
    attr_accessor :price, :fuel_type, :firm, :address, :company, :submit_datetime
    def initialize( data )
      @price = 0.0
      @fuel_type = '-'
      @firm = '-'
      @address = '-'
      @company = '-'
      @submit_datetime = Time.now
      
      unless data.empty?
        data.collect!{|i| i.strip}
        if data.size > 10
          #Price
          process_price( data[2].inner_text )
          
          #Fuel type
          @fuel_type = data[4].inner_text.strip
          
          #Firm
          @firm = process_text( data[5].inner_text )
          
          #Address
          @address = process_text( data[6].inner_text )
          
          #Company, sumbit datetime
          process_company_date( data[10].inner_html )
        end
      end
    end
    
    def process_price( text )
      parts = text.split(':').collect{|i| i.strip}
      if parts.size == 2
        if parts[1].match(/\d+/)
          parts[1].gsub!(',', '.')
          @price = parts[1].to_f
        end
      end
    end
    
    def process_text( text )
      text '-'
      parts = text.split(':').collect{|i| i.strip}
      text = parts[1] if parts.size == 2
      text
    end
    
    def process_company_date( text )
      parts = text.split("<br>")
      if parts.size == 2
        #Get company
        @company = parts[0].strip
        @company.gsub!('&amp;', '&')
        parts = parts.split(': ')
        if parts.size == 2
          @submit_datetime = parts[1].strip
        end
      end
    end
  end
  
  class Parser
    attr_accessor :stations
    def initialize( codes = [], fuel_type = 1)
      @stations = []
      
      unless codes.empty?
        begin
          doc = open("#{BASE_URL}#{codes.collect!{|i| "DD=#{i}"}.join('&')}&podclass=#{fuel_type}")
          unless doc.nil?
            doc = Iconv.conv('utf-8', 'iso-8859-7', doc.read.to_s)
            unless doc.empty?
              doc = Nokogiri::HTML( doc ) 
              entries = doc.search("td[@class='mainArea']/table")
              if entries.size > 2
                2.times do
                  entries.delete(entries.first)
                  
                  entries.each do |e|
                    @stations << Station.new( e.search("tr/td") )
                  end
                  
                end
              end
            end
          end
        rescue
        end
      end
    
    end
  
  end

end
