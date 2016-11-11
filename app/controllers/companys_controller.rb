class CompanysController < ApplicationController
  def new
  end
  
  def create
    
    @cp =  Company.new
    
    @cp.name = params[:coname]
    @cp.save
  
    redirect_to company_path(@cp)
  
  #redirect_to @cp
    
   #redirect_to mpoint_path(@cp)
  end

  def show
   @cp =  Company.find(params[:id])
   @mp =  @cp.mpoints.all
  end
  
  def setsushow
   @cp =  Company.find(params[:id])
   @mp =  @cp.mpoints.all
  end

  def index
  end
end
