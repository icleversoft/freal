class Api::V1::CitiesController < Api::V1::BaseController
  def index
    @location = [params[:lat], params[:lon]].collect{|i| i.to_f}
    cities = City.get_closest_cities(@location)
    data = []
    cities.each do |c|
      data << {:name => c.name, :location => c.location}
    end
    respond_with(:cities => data, location: @location)
  end
end
