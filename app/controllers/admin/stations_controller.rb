class Admin::StationsController < Admin::ManageController
  def index
    @page = params[:page]
    @page ||= 1
    @page = @page.to_i
    @stations = Station.all.asc(:address).page(@page)
  end
end
