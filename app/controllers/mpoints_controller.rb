class MpointsController < ApplicationController
  def new
    @cp =  Company.find(params[:cnum])
    
    
    #@nmv.save
  end
  
  def create
    
  @cp =  Company.find(params[:co_id])
  @nmv = @cp.mpoints.new
  @nmv.pname = params[:pname]
  @nmv.save
  
  redirect_to company_path(@cp)
  
  #redirect_to @cp
    
   #redirect_to mpoint_path(@cp)
  end

  def show
     @mp =  Mpoint.find(params[:id])
     @mv =  @mp.mvalues.all.reverse
     @trp =  @mp.trparams.all
  end

  def index
  end

  def edit
  end
end
