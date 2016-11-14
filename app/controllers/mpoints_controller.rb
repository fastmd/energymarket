class MpointsController < ApplicationController
  def new
    @cp =  Company.find(params[:cnum])
    
    
    #@nmv.save
  end
  
  def create
    
  @cp =  Company.find(params[:co_id])
  @nmv = @cp.mpoints.new
  @nmv.messtation = params[:messtation]
  @nmv.pname = params[:meconname]
  @nmv.pname = params[:clsstation]
  @nmv.pname = params[:clconname]
  @nmv.pname = params[:voltcl]
  @nmv.pname = params[:metertype]
  @nmv.pname = params[:meternum]
  @nmv.pname = params[:koeftt]
  @nmv.pname = params[:koeftn]
  @nmv.pname = params[:koefcalc]
  
  @nmv.save
  
  redirect_to company_path(@cp)
  
  #redirect_to @cp
    
   #redirect_to mpoint_path(@cp)
  end

  def show
     @mp =  Mpoint.find(params[:id])
     @mv =  @mp.mvalues.all.reverse
     @trp =  @mp.trparams.all
     @lnp =  @mp.lineprs.all
  end

  def index
  end

  def edit
  end
end
