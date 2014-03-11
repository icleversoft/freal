class Api::V1::CitiesController < Api::V1::BaseController
  def index
    render :json => {params: params.to_json}
  end
end
