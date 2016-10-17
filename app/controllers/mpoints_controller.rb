class MpointsController < ApplicationController
  def new
    @cp =  Company.find(params[:cnum])
    @nmv = @cp.mpoints.new
    
    #@nmv.save
  end
  
  def create
    
  @cp =  Company.find(params[:co_id])
  
  redirect_to root_path
  
  #redirect_to @cp
    
   #redirect_to mpoint_path(@cp)
  end

  def show
     @mp =  Mpoint.find(params[:id])
     @mv =  @mp.mvalues.all
  end

  def index
  end

  def edit
  end
end
