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
      if @flag.nil? then
        if @mvs.count==0 then
          @mv_params = {:mv_id=>nil,:meter_id=>if @mets.size!=0 then @mets[0][1] end,:actp180=>nil,:actp280=>nil,:actp380=>nil,:actp480=>nil,:actdate=>Date.current,:comment=>nil} 
        else 
          @mv_params = {:mv_id=>nil,:meter_id=>@mvs.first.meter_id,:actp180=>@mvs.first.actp180,:actp280=>@mvs.first.actp280,
                        :actp380=>@mvs.first.actp380,:actp480=>@mvs.first.actp480,
                        :actdate=>Date.current,:comment=>nil} 
        end                
      elsif (@flag=='mvedit' || @flag=='mvadd') then
         @mv_params = {:mv_id=>params[:mv_id],:meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280=>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                       :actdate=>params[:actdate],:comment=>params[:comment]}
         @meter_id = params[:meter_id]
         @actp180 = params[:actp180]
         @actp280 = params[:actp280]
         @actp380 = params[:actp380]
         @actp480 = params[:actp480]
         @actdate = params[:actdate]
         @comment = params[:comment]
         @mv_id =  params[:mv_id]    
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
