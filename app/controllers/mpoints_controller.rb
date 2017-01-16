class MpointsController < ApplicationController
  def new  
  end
  
  def create    
    @cp =  Company.find(params[:company_id])
    @nmv = @cp.mpoints.new
    @nmv.messtation = params[:messtation]
    @nmv.meconname = params[:meconname]
    @nmv.clsstation = params[:clsstation]
    @nmv.clconname = params[:clconname]
    @nmv.voltcl = params[:voltcl]
    @nmv.comment = params[:comment]
    @nmv.save 
    redirect_to company_path(@cp)  
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
    @trp = @mp.trparams.all
    @lnp = @mp.lineprs.all
    @mets=Array[]
    i=0     
    if !(params[:met]).nil? then  @met = Meter.find(params[:met])
                                  @mv = @met.mvalues.all.order(actdate: :desc)
                                  @mets[i] = [(@met.meternum).to_s+" "+(@met.metertype).to_s[0,3]+" ( "+(@met.relevance_date).to_s+" ) ", @met.id]
                            else  met = @mp.meters.all.order('relevance_date desc nulls last', created_at: :desc)
                                  @mv = @mp.mvalues.all.order(actdate: :desc)
                                  met.each do |item|
                                      @mets[i] = [(item.meternum).to_s+" "+(item.metertype).to_s[0,3]+" ( "+(item.relevance_date).to_s+" ) ", item.id]
                                      i+=1    
                                  end                                 
    end      
    @mv = @mv.paginate(:page => params[:page], :per_page => @perpage = 10)      
    respond_to do |format|
      format.html
#      format.csv { send_data @mv.to_csv }
#      format.xls { send_data @trp.to_csv(col_sep: "\t") }
      format.pdf { send_data MpointsReport.new.to_pdf(@mv,@mp), :type => 'application/pdf', :filename => "history.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="history.xlsx"' }
    end
    @flag = params[:flag]   
  end

  def index
  end

  def edit
  end
end
