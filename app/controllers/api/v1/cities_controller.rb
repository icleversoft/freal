class Api::V1::CitiesController < Api::V1::BaseController
  before_filter :find_device
  def index
    location = [params[:lat], params[:lon]].collect{|i| i.to_f}
    # city = City.get_closest_cities(location).first
    stations = Station.get_closest_stations(location)
    if stations.empty? #city.nil?
      respond_with(message: 'Not found any station', status: 400)
    else
      # stations = []
      # cities.each{|s| s.city_municipality.each{|x| stations << x}}
      # city = cities.first
      respond_with(:location => location, :stations => stations.collect{|i| i.api_attributes}, status: 200)
      # respond_with(:id => city._id, :name => city.name, :location => location, :stations => city.city_municipality, status: 200)
    end
    
  end
  
  def mystation
    if @device.nil?
      render json: {msg: 'Device token not found!'}, status: 404
    else
      fav = @device.favorites.where(station_id: params[:id]).first
      if fav.nil?
        render json: {msg: 'Station not found!'}, status: 404
      else
        render json: {station: fav.station.api_attributes}
      end
    end
  end

  def myfavorites
    if @device.nil?
      render json: {msg: 'Device token not found!'}, status: 404
    else
      render json: {favorites: @device.favorites.collect{|i| i.station.api_attributes}}
    end
  end

private  

  def find_device
    @device = nil
    token = params[:token]
    token ||= ''
    token = token.strip
    unless token.empty?
      @device = Device.where(token: token ).first
    end
  end
  
end
