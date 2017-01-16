class FilialsController < ApplicationController
  def index
  end

  def show
    if current_user.has_role? :"setsu-nord"  
      @fl =  Filial.find(1)
      @companies = @fl.companys.order(name: :asc)
      @companies = @companies.paginate(:page => params[:page], :per_page => @perpage = 10)
    else
      @fl =  Filial.find(params[:id])
      @companies = @fl.companys.order(name: :asc)
      @companies = @companies.paginate(:page => params[:page], :per_page => @perpage = 10)  
    end
  end

  def edit
  end

  def new
  end
  
end
