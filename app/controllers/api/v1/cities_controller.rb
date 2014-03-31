class Api::V1::CitiesController < Api::V1::BaseController
  def index
    location = [params[:lat], params[:lon]].collect{|i| i.to_f}
    # city = City.get_closest_cities(location).first
    cities = City.get_closest_cities(location)
    if cities.empty? #city.nil?
      respond_with(message: 'Not found any city', status: 400)
    else
      stations = []
      cities.each{|s| s.city_municipality.each{|x| stations << x}}
      city = cities.first
      respond_with(:id => city._id, :name => city.name, :location => location, :stations => stations, status: 200)
      # respond_with(:id => city._id, :name => city.name, :location => location, :stations => city.city_municipality, status: 200)
    end
  end
end
