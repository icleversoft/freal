class Api::V1::CitiesController < Api::V1::BaseController
  def index
    location = [params[:lat], params[:lon]].collect{|i| i.to_f}
    city = City.get_closest_cities(location).first
    if city.nil?
      respond_with(message: 'Not found any city'), status: 400
    else
      respond_with(:id => city._id, :name => city.name, :location => location, :stations => city.city_municipality), status: 200
    end
  end
end
