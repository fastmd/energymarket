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
    if current_user.has_role? :"setsu-nord"
      @fpr = 1
    end 
    if current_user.has_role? :"setsu-nord-vest"
      @fpr = 2
    end
    if current_user.has_role? :"setsu-centru"
      @fpr = 3
    end
    if current_user.has_role? :"setsu-sud"
      @fpr = 4
    end
    if current_user.has_role? :"setsu"
      @fpr = 5
    end
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
