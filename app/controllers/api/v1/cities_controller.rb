class Api::V1::CitiesController < Api::V1::BaseController
  def index
    @location = [params[:lat], params[:lon]].collect{|i| i.to_f}
    cities = City.get_closest_cities(@location)
    cities = cities.map{|i| City.find(i.id)}
    data = []
    cities.each do |c|
      data << {_id: c._id, :name => c.name, :location => c.location, stations: c.municipality.stations.collect{|i| i.api_attributes}}
    end
    respond_with(:cities => data, location: @location)
  end
end
