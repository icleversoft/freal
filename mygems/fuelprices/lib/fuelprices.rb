require "fuelprices/version"
require 'open-uri'
#d=Nokogiri::HTML(open('http://www.fuelprices.gr/CheckPrices?DD=A1140100&prodclass=1'))
#entries = d.search("td[@class='mainArea']/table")
# if entries.size > 2
#   2.times do
#     entries.delete(entries.first)
#   end
# end
module Fuelprices
  BASE_URL = "http://anonymouse.org/cgi-bin/anon-www.cgi/http://www.fuelprices.gr/CheckPrices?"
  class Station
    attr_accessor :price, :fuel_type, :firm, :address, :company, :submit_datetime, :code, :ft
    def initialize( area, data, ft )
      @code = area
      @ft = ft
      @price = 0.0
      @fuel_type = '-'
      @firm = '-'
      @address = '-'
      @company = '-'
      @submit_datetime = '-'
      
      unless data.empty?
        if data.size > 10
          #Price
          process_price( data[2].inner_text )
          
          #Fuel type
          @fuel_type = data[4].inner_text.strip.encode("UTF-8") unless data[4].inner_text.strip.nil?
          
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
      parts = text.split(':').collect{|i| i.strip}
      text = parts.size == 2 ? parts[1] : '-'
      text = text.encode("UTF-8") unless text.nil?
      text
    end
    
    def process_company_date( text )
      parts = text.split("<br>")
      if parts.size == 2
        #Get company
        @company = parts[0].strip
        @company.gsub!('&amp;', '&')
        @company = @company.encode("UTF-8") unless @company.nil?
        parts = parts[1].split(': ')
        if parts.size == 2
          @submit_datetime = parts[1].strip
          @submit_datetime = @submit_datetime.encode("UTF-8") unless @submit_datetime.nil?
        end
      end
    end

    # def company
    #   ret = @company
    #   begin
    #     ret = Iconv.conv('utf-8', 'iso-8859-7', ret)
    #   rescue
    #     ret = @company
    #   end
    #   ret
    # end    
  end
  
  class Parser
    attr_accessor :stations
    def initialize( area, codes = [], fuel_type = 1)
      @stations = []
      
      unless codes.empty?
        begin
          url = "#{BASE_URL}#{codes.collect{|i| "DD=#{i}"}.join('&')}&prodclass=#{fuel_type}"
          p url
          doc = open( url )
          
          unless doc.nil?
            doc = doc.read.to_s
            # doc = Iconv.conv('utf-8', 'windows-1253', doc.read.to_s)
            unless doc.empty?
              doc = Nokogiri::HTML( doc ) 
              entries = doc.search("td[@class='mainArea']/table")
              p entries.size
              if entries.size > 2
                2.times do
                  entries.delete(entries.first)
                end
                entries.each do |e|
                  @stations << Station.new( area, e.search("tr/td"), fuel_type )
                end
              end
            end
          end
        rescue => e
          p e.message
          @stations = nil
        end
      end
    
    end
  
  end

end
