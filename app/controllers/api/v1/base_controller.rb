class Api::V1::BaseController <  ApplicationController
  before_filter :authenticate_user!, :unless => :devise_controller?
  respond_to :json

private 
  def auth_me
    Rails.logger.info "INFO:------->#{request.headers.inspect}"
  end
  
end