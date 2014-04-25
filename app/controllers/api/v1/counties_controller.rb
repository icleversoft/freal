class Api::V1::CountiesController < Api::V1::BaseController
  
  def all
    counties = County.all.asc(:name).collect{|i| i.api_attributes}
    respond_with(counties: counties)
  end

  def municipalities
    county = County.find(params[:id])
    municipalities = county.municipalities.all.asc(:name)
    values = municipalities.collect{|i| i.api_attributes}
    respond_with(county: county.api_attributes, municipalities: values)
  end
  
end
