class MpointsController < ApplicationController
before_filter :redirect_cancel, only: [:create, :update] 
before_filter :check_user, only: [:create, :edit, :show, :update]  
  
  def new  
  end
  
  def create    
    @cp =  Company.find(params[:company_id])
    @mpoint = @cp.mpoints.build
    @mpoint = mpoint_init(@mpoint)  
    begin
      if @mpoint.save! then 
        flash.discard
        redirect_to company_path(:id => @cp.id) 
      end
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'add'
      @mp =  @cp.mpoints.order(name: :asc, created_at: :desc) 
      @mp =  @mp.paginate(:page => params[:page], :per_page => @perpage = $PerPage ) 
      if @fpr < 6 then  @flr = @cp.filial else @flr =  @cp.furnizor end
      render "companies/show" 
    end   
  end
  
  def update
    @mpoint = Mpoint.find(params[:id])
    @mpoint = mpoint_init(@mpoint)
    @cp  = @mpoint.company
    begin
      @mpoint.save! 
      flash.discard
      redirect_to company_path(:id => @cp.id) 
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'edit'
      @mp =  @cp.mpoints.order(name: :asc, created_at: :desc) 
      @mp =  @mp.paginate(:page => params[:page], :per_page => @perpage = $PerPage )
      if @fpr < 6 then  @flr = @cp.filial else @flr =  @cp.furnizor end 
      render "companies/show" 
    end      
  end
  
  def edit
    @flag = 'edit'
    @mpoint = Mpoint.find(params[:mp_id])
    @cp  = @mpoint.company
    @mp =  @cp.mpoints.order(name: :asc, created_at: :desc) 
    @mp =  @mp.paginate(:page => params[:page], :per_page => @perpage = $PerPage )
    if @fpr < 6 then  @flr = @cp.filial else @flr =  @cp.furnizor end
    flash.discard 
    render "companies/show"    
  end

  def show
    @mp =  Mpoint.find(params[:id])
    @cp  = @mp.company
    @flag = params[:flag]
    
    if (current_user.has_role? :cduser) || (@fpr > 5) then
      @mets = Array[]
      i=0     
      unless (params[:met]).nil? || (params[:met]) == ''  then  
                                    @met = Meter.find(params[:met])
                                    @mvs_all_pages = @met.mvalues.all.order(actdate: :desc, created_at: :desc, updated_at: :desc)
                                    @mvs = @mvs_all_pages
                                    @mets[i] = [(@met.meternum).to_s+" "+(@met.metertype).to_s[0,3]+" ( "+(@met.relevance_date).to_s+" ) ", @met.id]
      else                          @met = nil
                                    met = @mp.meters.all.order('relevance_date desc nulls last', created_at: :desc)
                                    @mvs_all_pages = @mp.mvalues.all.order(actdate: :desc, created_at: :desc, updated_at: :desc)
                                    @mvs = @mvs_all_pages
                                    met.each do |item|
                                        @mets[i] = [(item.meternum).to_s+" "+(item.metertype).to_s[0,3]+" ( "+(item.relevance_date).to_s+" ) ", item.id]
                                        i+=1    
                                    end                                 
      end
      if @flag.nil? then
        if @mvs.count==0 then
          @mv_params = {:mv_id=>nil,:meter_id=>if @mets.size!=0 then @mets[0][1] end,:actp180=>nil,:actp280=>nil,:actp380=>nil,:actp480=>nil,
                        :actdate=>Date.current,:comment=>nil,:f=>'true'} 
        else 
          @mv_params = {:mv_id=>nil,:meter_id=>@mvs.first.meter_id,:actp180=>@mvs.first.actp180,:actp280=>@mvs.first.actp280,
                        :actp380=>@mvs.first.actp380,:actp480=>@mvs.first.actp480,
                        :actdate=>Date.current,:comment=>nil,:f=>'true'} 
        end                
      elsif (@flag=='mvedit' || @flag=='mvadd') then
         @mv_params = {:mv_id=>params[:mv_id],:meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280=>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                       :actdate=>params[:actdate],:comment=>params[:comment],:f=>params[:f]}   
      end       
      @mvs = @mvs.paginate(:page => params[:page], :per_page => @perpage = $PerPage)      
      respond_to do |format|
        format.html
        #format.csv { send_data @mv.to_csv }
        #format.xls { send_data @trp.to_csv(col_sep: "\t") }
        format.pdf { send_data MpointsReport.new.to_pdf(@mvs_all_pages,@mp), :type => 'application/pdf', :filename => "history.pdf" }
        format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="history.xlsx"' }
      end
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
  
  def destroy
    mp = Mpoint.find(params[:mp_id])
    mt_count = mp.meters.count
    tr_count = mp.trparams.count
    ln_count = mp.lnparams.count
    if  mt_count!=0 || tr_count!=0 || ln_count!=0 then 
      flash[:warning] = "Нельзя удалить точку учета #{mp.name}: #{mp.messtation} / #{mp.clsstation}, #{mp.meconname} / #{mp.clconname}, которой принадлежат счетчики (#{mt_count} шт.), трансформаторы (#{tr_count} шт.) или линии (#{ln_count} шт.)!" 
    else 
      begin
        mp.destroy!
        flash[:notice] = "Точка учета удалена!"
      rescue
        flash[:warning] = "Не удалось удалить точку учета #{mp.name}: #{mp.messtation} / #{mp.clsstation}, #{mp.meconname} / #{mp.clconname}!" 
      end      
    end
    redirect_to company_path(:id => mp.company.id)
  end  
     
private

  def redirect_cancel
    if params[:cancel] then
      flash.discard 
      redirect_to company_path(:id => params[:company_id], :flag => nil)
    end   
  end 
  
  def mpoint_init(mpoint)
    t = params[:name]
    t = t.lstrip
    t = t.rstrip
    mpoint.name = t
    t = params[:messtation]
    t = t.lstrip
    t = t.rstrip        
    mpoint.messtation = t
    t = params[:meconname]
    t = t.lstrip
    t = t.rstrip    
    mpoint.meconname = t
    t = params[:clsstation]
    t = t.lstrip
    t = t.rstrip    
    mpoint.clsstation = t
    t = params[:clconname]
    t = t.lstrip
    t = t.rstrip    
    mpoint.clconname = t
    mpoint.voltcl = params[:voltcl]  
    mpoint.comment = params[:comment]
    mpoint.f = if params[:f].nil? then false else true end  
    mpoint    
  end      
  
end
