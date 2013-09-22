class Admin::MunicipalitiesController < Admin::ManageController
  def index
  end

  def cities
    if request.xhr?
      @mun = Municipality.find(params[:id])
      @cities = @mun.cities
    else
      render :nothing => true
    end
  end
  
end
