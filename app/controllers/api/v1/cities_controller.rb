class Api::V1::CitiesController < Api::V1::BaseController
  before_filter :find_device, :except => [:all, :nearme, :find_by_name, :autocomplete]
  
  def autocomplete
    query = params[:query]
    cities = []
    if !query.nil? && !query.strip.empty?
      cities = City.search(query.gr_downcase, fields: [{name: :text_start}], limit: 10).map(&:name)#collect{|i| "#{i.name}|#{i._id}"}
    end
    respond_with(cities: cities, query: query)
  end
  
  def find_by_name
    query = params[:query]
    query ||= '*'
    page = params[:page]
    page ||= 1
    page = page.to_i
    per_page = 10
    # Rails.logger.debug "#{query} --- #{query.gr_downcase}"
    cities = City.search( query.gr_downcase, fields:[{name: :word_start}], page: page, per_page: per_page  )
    # cities = City.search query: {match: {name: query}}
    
    values = cities.collect{|i| i.api_attributes}
    respond_with(cities: values, page: page, has_more: values.size == 10, query: query)
  end
  
  def all
    page = params[:page]
    page ||= 1
    page = page.to_i
    per_page = 10
    cities = City.all.asc(:name).page(page).per(per_page)
    values = cities.collect{|i| i.api_attributes}
    # cities = City.search "*", order: {name: :asc}#, limit: per_page, offset: (page - 1)
    respond_with(cities: values, page: page, has_more: values.size == 10)
  end
  
  def nearme
    location = [params[:lat], params[:lon]]
    city = City.nearby_city(params[:lat], params[:lon])
    if city.nil?
      respond_with(message: 'Not found any station', status: 400)
    else
      respond_with(city: {name: city.name, code: city.code, location: location}, :stations => city.municipality.stations.where(:updated_at.gte=> 20.days.ago).collect{|i| i.api_attributes}, status: 200)
    end
  end
  
  def index1
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
