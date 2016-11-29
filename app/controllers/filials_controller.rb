class FilialsController < ApplicationController
  def index
  end

  def show
    @fl =  Filial.find(params[:id])
    @companies = @fl.companys.all
  end

  def edit
  end

  def new
  end
end
