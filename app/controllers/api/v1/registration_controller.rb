class Api::V1::RegistrationController < Api::V1::BaseController
  def create
    @device = Device.find_or_create_by(token: params[:token] )
    name, dmodel, version, appVersion = [params[:name], params[:model], params[:version], params[:app_version]]
    
    name ||= ''
    dmodel ||= ''
    version ||= ''
    appVersion ||= ''
    @device.update_attributes(name: name, model: dmodel, version: version, appVersion: appVersion)

    render :json => @device.to_json
  end
end
