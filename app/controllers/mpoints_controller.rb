class MpointsController < ApplicationController
  def new
    @cp =  Company.find(params[:cnum])
    
    
    #@nmv.save
  end
  
  def create
    
  @cp =  Company.find(params[:co_id])
  @nmv = @cp.mpoints.new
  @nmv.messtation = params[:messtation]
  @nmv.meconname = params[:meconname]
  @nmv.clsstation = params[:clsstation]
  @nmv.clconname = params[:clconname]
  @nmv.voltcl = params[:voltcl]
  @nmv.metertype = params[:metertype]
  @nmv.meternum = params[:meternum]
  @nmv.koeftt = params[:koeftt]
  @nmv.koeftn = params[:koeftn]
  @nmv.koefcalc = params[:koefcalc]
  
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
