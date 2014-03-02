class Admin::CitiesController < Admin::ManageController
  def index
    @page = params[:page]
    @page ||= 1
    @page = @page.to_i
    
    @cities = City.all.asc(:name).page(@page)
  end
end
