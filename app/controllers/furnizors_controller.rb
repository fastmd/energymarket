class FurnizorsController < ApplicationController
  def new
  end

  def index
  end

  def edit
  end
  
  def show
    @company = Company.new  
    @fr =  Furnizor.find(params[:id])
    @companies = @fr.companys.all.order(name: :asc)
    @companies = @companies.paginate(:page => params[:page], :per_page => $PerPage )
  end
end
