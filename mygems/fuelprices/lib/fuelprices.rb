require "fuelprices/version"
#d=Nokogiri::HTML(open('http://www.fuelprices.gr/CheckPrices?DD=A1140100&prodclass=1'))
#entries = d.search("td[@class='mainArea']/table")
# if entries.size > 2
#   2.times do
#     entries.delete(entries.first)
#   end
# end
module Fuelprices
  # Your code goes here...
end
