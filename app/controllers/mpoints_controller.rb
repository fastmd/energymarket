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
    @flag = params[:flag]
    if (current_user.has_role? :cduser) || (@fpr > 5) then
      if !@flag.nil? && (@flag=='mvedit' || @flag=='mvadd') then
         @mv.meter_id = params[:meter_id]
         @mv.actp180 = params[:actp180]
         @mv.actp280 = params[:actp280]
         @mv.actp380 = params[:actp380]
         @mv.actp480 = params[:actp480]
         @mv.actdate = params[:actdate]
         @mv.comment = params[:comment]     
      end 
      @mets = Array[]
      i=0     
      unless (params[:met]).nil? || (params[:met]) == ''  then  
                                    @met = Meter.find(params[:met])
                                    @mvs = @met.mvalues.all.order(actdate: :desc, created_at: :desc, updated_at: :desc)
                                    @mets[i] = [(@met.meternum).to_s+" "+(@met.metertype).to_s[0,3]+" ( "+(@met.relevance_date).to_s+" ) ", @met.id]
      else                          @met = nil
                                    met = @mp.meters.all.order('relevance_date desc nulls last', created_at: :desc)
                                    @mvs = @mp.mvalues.all.order(actdate: :desc, created_at: :desc, updated_at: :desc)
                                    met.each do |item|
                                        @mets[i] = [(item.meternum).to_s+" "+(item.metertype).to_s[0,3]+" ( "+(item.relevance_date).to_s+" ) ", item.id]
                                        i+=1    
                                    end                                 
      end      
      @mvs = @mvs.paginate(:page => params[:page], :per_page => @perpage = $PerPage)      
      #respond_to do |format|
      #  format.html
        #format.csv { send_data @mv.to_csv }
        #format.xls { send_data @trp.to_csv(col_sep: "\t") }
      #  format.pdf { send_data MpointsReport.new.to_pdf(@mv,@mp), :type => 'application/pdf', :filename => "history.pdf" }
     #   format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="history.xlsx"' }
     # end
    else 
      @trp = @mp.trparams.all
      @lnp = @mp.lnparams.all 
      if !@flag.nil? && (@flag=='tedit' || @flag=='tadd') then
        @pxx  = params[:pxx]
        @pkz  = params[:pkz]
        @snom = params[:snom]
        @ukz  = params[:ukz]
        @io   = params[:io]
        @comment = params[:comment] 
        @tr_id = params[:tr_id]
        @f  = params[:f]      
      end   
      if !@flag.nil? && (@flag=='ledit' || @flag=='ladd') then
        @l  = params[:l]
        @ro  = params[:ro]      
        @k_scr = params[:k_scr]
        @k_tr = params[:k_tr]
        @k_peb = params[:k_peb] 
        @k_f = params[:k_f] 
        @q = params[:q]
        @comment = params[:comment] 
        @line_id = params[:line_id]
        @f = params[:f]        
      end 
    end    
  end

  def index
  end

  def edit
  end
end
