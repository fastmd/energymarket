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
    if current_user.has_role? :"setsu-nord"      then  @fpr = 1 end 
    if current_user.has_role? :"setsu-nord-vest" then  @fpr = 2 end
    if current_user.has_role? :"setsu-centru"    then  @fpr = 3 end
    if current_user.has_role? :"setsu-sud"       then  @fpr = 4 end
    if current_user.has_role? :"setsu"           then  @fpr = 5 end
    if current_user.has_role? :"cduser"          then  @fpr = 6 end
    if current_user.has_role? :"cduser-fee"      then  @fpr = 7 end
    if current_user.has_role? :"cduser-fenosa"   then  @fpr = 8 end
     @mp =  Mpoint.find(params[:id])
     @mv =  @mp.mvalues.all.reverse
     @trp =  @mp.trparams.all
     @lnp =  @mp.lineprs.all 
    respond_to do |format|
      format.html
#      format.csv { send_data @mv.to_csv }
#      format.xls { send_data @trp.to_csv(col_sep: "\t") }
      format.pdf { send_data MpointsReport.new.to_pdf(@mv,@mp), :type => 'application/pdf', :filename => "history.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="history.xlsx"' }
    end   
  end

  def index
  end

  def edit
  end
end
