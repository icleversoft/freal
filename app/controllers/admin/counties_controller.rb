class Admin::CountiesController < Admin::ManageController
  def index
    @page = params[:page]
    @page ||= 1
    @page = @page.to_i
    @counties = County.all.asc(:name).page(@page)
  end
  
  def show
    @county = County.find(params[:id])
    @muns = @county.municipalities
  end
end
