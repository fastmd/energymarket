class FilialsController < ApplicationController
  def index
  end

  def show
    @company = Company.new
    if current_user.has_role? :"setsu-nord"  
      @fl =  Filial.find(1)
      @companies = @fl.companys.order(name: :asc)
      @companies = @companies.paginate(:page => params[:page], :per_page => $PerPage)
    else
      @fl =  Filial.find(params[:id])
      @companies = @fl.companys.order(name: :asc)
      @companies = @companies.paginate(:page => params[:page], :per_page => $PerPage)  
    end
  end

  def edit
  end

  def new
  end
  
end
