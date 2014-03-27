class Api::V1::CitiesController < Api::V1::BaseController
  def index
    location = [params[:lat], params[:lon]].collect{|i| i.to_f}
    city = City.get_closest_cities(location).first
    respond_with(:id => city._id, :name => city.name, :location => location, :stations => city.city_municipality)
  end
end
