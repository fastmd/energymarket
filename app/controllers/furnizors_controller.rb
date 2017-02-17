class FurnizorsController < ApplicationController
before_filter :check_user  
  
  def new
  end

  def index
  end

  def edit
  end
  
  def show
    @page = params[:page].to_i 
    if params[:page] == 0 then 1 else params[:page] end
    @company = Company.new  
    @flr =  Furnizor.find(params[:id])
    @companies = @flr.companies.all.order(name: :asc)
    if @companies.count > @page * $PerPage then @page = 1 end
    unless @companies.nil? then @companies = @companies.paginate(:page => @page, :per_page => $PerPage ) end
  end
   
end
