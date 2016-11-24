class FurnizorsController < ApplicationController
  def new
  end

  def index
  end

  def edit
  end
  
  def show
    @fr =  Furnizor.find(params[:id])
    @companies = @fr.companys.all
  end
end
