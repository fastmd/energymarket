class FilialsController < ApplicationController
  def index
  end

  def show
    if current_user.has_role? :"setsu-nord"  
      @fl =  Filial.find(1)
      @companies = @fl.companys.all
    elsif
      @fl =  Filial.find(params[:id])
      @companies = @fl.companys.all  
    end
  end

  def edit
  end

  def new
  end
end
