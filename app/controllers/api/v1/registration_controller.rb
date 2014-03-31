class Api::V1::RegistrationController < Api::V1::BaseController
  before_filter :find_device
  
  def create
    if !@device.nil?
      name, dmodel, version, appVersion = [params[:name], params[:model], params[:version], params[:app_version]]
    
      name ||= ''
      dmodel ||= ''
      version ||= ''
      appVersion ||= ''
      @device.update_attributes(name: name, model: dmodel, version: version, appVersion: appVersion)

      render :json => @device.to_json, :status => 200
    else
      render :json => {message: "Invalid device token!"}, :status => 500
    end
  end
  
  def observe_station
    if !@device.nil?
      station = Station.where(:id => params[:station_id]).first
      if !station.nil?
        if station.favorites.where(:station => station).first.nil?
          Favorite.create(station: station, device: @device)
          station.save
          @device.save
          render :json => {message: 'OK'}, status: 200
        else
          render :json => {message: 'Station is already into the observer list'}, status: 500
        end
      else
        render :json => {message: 'Station not found'}, status: 500
      end
    else
      render :json => {message: "Invalid device token!"}, :status => 500
    end
  end

private

  def find_device
    @device = nil
    token = params[:token]
    token ||= ''
    token = token.strip
    unless token.empty?
      @device = Device.find_or_create_by(token: token )
    end
  end
  
end
