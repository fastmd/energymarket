class MpointsController < ApplicationController
before_filter :check_user   
before_filter :redirect_cancel, only: [:create, :update]
helper_method :sort_column, :sort_direction   
  
  def helpmvalue
    @pagename = 'Справка-Показания'
    @mp =  Mpoint.find(params[:id])
    unless (params[:met]).nil? || (params[:met]) == ''  then  @met = Meter.find(params[:met]) end 
  end
  
  def new  
  end
  
  def create 
    begin   
      @cp =  Company.find(params[:company_id])
      @mpoint = @cp.mpoints.build
      @mpoint = mpoint_init(@mpoint)  
      @mpoint.save! 
      flash.discard
      redirect_to company_path(:id => @cp.id, :flr_id => params[:flr_id])       
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'add'
      if @fpr < 6 then @flr = @mpoint.filial else @flr = @mpoint.furnizor end
      @mp =  Vallmpoint.where(if @fpr < 6 then "filial_id = ? and company_id = ?" else "furnizor_id = ? and company_id = ?" end, @flr.id, @cp.id).order(name: :asc, created_at: :asc)  
      @mp =  @mp.paginate(:page => params[:page], :per_page => @perpage = $PerPage ) 
      @sstations = Mesubstation.all.pluck(:name, :id)
      filial_furnizor     
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
      redirect_to company_path(:id => @cp.id, :flr_id => params[:flr_id]) 
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'edit'
      if @fpr < 6 then @flr = @mpoint.filial else @flr = @mpoint.furnizor end
      @mp = Vallmpoint.where(if @fpr < 6 then "filial_id = ? and company_id = ?" else "furnizor_id = ? and company_id = ?" end, @flr.id, @cp.id).order(name: :asc, created_at: :asc)  
      @mp =  @mp.paginate(:page => params[:page], :per_page => @perpage = $PerPage )
      @sstations = Mesubstation.all.pluck(:name, :id)  
      filial_furnizor         
      render "companies/show" 
    end      
  end
  
  def edit
    @flag = 'edit'
    @mpoint = Mpoint.find(params[:mp_id])
    @cp  = @mpoint.company
    if @fpr < 6 then @flr = Filial.find(params[:flr_id]) else @flr = Furnizor.find(params[:flr_id]) end
    @mp =  Vallmpoint.where(if @fpr < 6 then "filial_id = ? and company_id = ?" else "furnizor_id = ? and company_id = ?" end, @flr.id, @cp.id).order(name: :asc, created_at: :asc) 
    @mp =  @mp.paginate(:page => params[:page], :per_page => @perpage = $PerPage )
    @sstations = Mesubstation.all.pluck(:name, :id)
    filial_furnizor    
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
                                    @mvs_all_pages = Vallmetersmvalue.where("?=id",@met.id).order(actdate: :desc, updated_at: :desc)
                                    @mvs = @mvs_all_pages
                                    @mets[i] = ["#{@met.meternum} | #{@met.relevance_date}", @met.id]
      else                          @met = nil
                                    met = @mp.meters.all.order('relevance_date desc nulls last', created_at: :desc)
                                  #  @mvs_all_pages = @mp.mvalues.all.order(actdate: :desc, created_at: :desc, updated_at: :desc)
                                    @mvs_all_pages = @mp.vallmetersmvalues.all.order(actdate: :desc, relevance_date: :desc,updated_at: :desc)
                                    @mvs = @mvs_all_pages
                                    met.each do |item|
                                        @mets[i] = ["#{item.meternum} | #{item.relevance_date}", item.id]
                                        i+=1    
                                    end                                 
      end
      if @flag.nil? then
        if @mvs.count==0 then
          @mv_params = {:mv_id=>nil,:meter_id=>if @mets.size!=0 then @mets[0][1] end,:actp180=>nil,:actp280=>nil,:actp380=>nil,:actp480=>nil,:trab=>nil,:dwa=>nil,:undercount=>nil,
                        :actdate=>Date.current,:comment=>nil,:f=>'true',:r=>'true',:fanulare=>nil,:fnefact=>'true'} 
        else 
          @mv_params = {:mv_id=>nil,:meter_id=>@mvs.first.id,:actp180=>@mvs.first.actp180,:actp280=>@mvs.first.actp280,
                        :actp380=>@mvs.first.actp380,:actp480=>@mvs.first.actp480,
                        :actdate=>Date.current,:comment=>nil,:f=>'true',:r=>'true',:fanulare=>nil,:fnefact=>'true'} 
        end                
      elsif (@flag=='mvedit' || @flag=='mvadd') then
         @mv_params = {:mv_id=>params[:mv_id],:meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280=>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                       :trab=>params[:trab],:dwa=>params[:dwa],:undercount=>params[:undercount],
                       :actdate=>params[:actdate],:comment=>params[:comment],:f=>params[:f],:r=>params[:r],:fanulare=>params[:fanulare],:fnefact=>params[:fnefact]}   
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
      @transformators = Transformator.where("f = ?", true).order(name: :asc).pluck(:name, :id)
      @lines = Vline.where("mesubstation_id = ? or mesubstation2_id = ?", @mp.mesubstation, @mp.mesubstation).order(name: :asc)
      @trp = @mp.trparams.all
      @lnp = @mp.valllnparams.all.order(condate: :desc, line_id: :asc)
      @tau = Tau.all
      @tr_id = params[:tr_id]
      @ln_id = params[:ln_id] 
      if @tr_id then @tr = Trparam.find(@tr_id) else @tr = @mp.trparams.build end
      if @ln_id then @ln = Lnparam.find(@ln_id) else @ln = @mp.lnparams.build end
      if !@flag.nil? && (@flag=='tedit' || @flag=='tadd') then
        if (params.has_key?(:comment)) then @tr.comment = params[:comment] end  
        if (params.has_key?(:transformator_id)) then @tr.transformator_id = params[:transformator_id] end 
        if (params.has_key?(:f)) then @tr.f  = params[:f] end      
      end   
      if !@flag.nil? && (@flag=='ledit' || @flag=='ladd') then
        if (params.has_key?(:condate)) then @ln.condate = params[:condate] end 
        if (params.has_key?(:comment)) then @ln.comment = params[:comment] end  
        if (params.has_key?(:line_id)) then @ln.line_id = params[:line_id] end 
        if (params.has_key?(:f)) then @ln.f =  params[:f] end      
      end 
      #render inline: "<%= @lines.inspect %><br><br>" and return 
    end   
  end

def showmvalues
    @mp =  Mpoint.find(params[:id])
    @cp  = @mp.company
    @flag = params[:flag]
    
      @mets = Array[]
      i=0     
      unless (params[:met]).nil? || (params[:met]) == ''  then  
                                    @met = Meter.find(params[:met])
                                    @mvs_all_pages = Vallmetersmvalue.where("?=id",@met.id).order(actdate: :desc, updated_at: :desc)
                                    @mvs = @mvs_all_pages
                                    @mets[i] = ["#{@met.meternum} | #{@met.relevance_date}", @met.id]
      else                          @met = nil
                                    met = @mp.meters.all.order('relevance_date desc nulls last', created_at: :desc)
                                    @mvs_all_pages = @mp.vallmetersmvalues.all.order(actdate: :desc, relevance_date: :desc,updated_at: :desc)
                                    @mvs = @mvs_all_pages
                                    met.each do |item|
                                        @mets[i] = ["#{item.meternum} | #{item.relevance_date}", item.id]
                                        i+=1    
                                    end                                 
      end
      if @flag.nil? then
        if @mvs.count==0 then
          @mv_params = {:mv_id=>nil,:meter_id=>if @mets.size!=0 then @mets[0][1] end,:actp180=>nil,:actp280=>nil,:actp380=>nil,:actp480=>nil,:trab=>nil,:dwa=>nil,:undercount=>nil,
                        :actdate=>Date.current,:comment=>nil,:f=>'true',:r=>'true'} 
        else 
          @mv_params = {:mv_id=>nil,:meter_id=>@mvs.first.id,:actp180=>@mvs.first.actp180,:actp280=>@mvs.first.actp280,
                        :actp380=>@mvs.first.actp380,:actp480=>@mvs.first.actp480,
                        :actdate=>Date.current,:comment=>nil,:f=>'true',:r=>'true'} 
        end                
      elsif (@flag=='mvedit' || @flag=='mvadd') then
         @mv_params = {:mv_id=>params[:mv_id],:meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280=>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                       :trab=>params[:trab],:dwa=>params[:dwa],:undercount=>params[:undercount],
                       :actdate=>params[:actdate],:comment=>params[:comment],:f=>params[:f],:r=>params[:r]}   
      end       
      @mvs = @mvs.paginate(:page => params[:page], :per_page => @perpage = $PerPage)      
      respond_to do |format|
        format.html
        #format.csv { send_data @mv.to_csv }
        #format.xls { send_data @trp.to_csv(col_sep: "\t") }
        format.pdf { send_data MpointsReport.new.to_pdf(@mvs_all_pages,@mp), :type => 'application/pdf', :filename => "history.pdf" }
        format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="history.xlsx"' }
      end 
  end


  def index
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end
    if params[:filter] then
        cookies[:qmesubstation] = @qmesubstation = params[:qmesubstation].to_s
        cookies[:qcompany] = @qcompany = params[:qcompany].to_s
        cookies[:qregion] = @qregion = params[:qregion].to_s
        cookies[:qfilial] = @qfilial = params[:qfilial].to_s
        cookies[:qfurnizor] = @qfurnizor = params[:qfurnizor].to_s
        @data_for_search = ''
        cookies.delete(:data_for_search) 
    else
        if params[:search] then
            cookies[:data_for_search] = @data_for_search = params[:q].to_s
            cookies.delete(:qmesubstation)
            cookies.delete(:qcompany)
            cookies.delete(:qregion)
            cookies.delete(:qfilial)
            cookies.delete(:qfurnizor)            
        else
            @data_for_search = cookies[:data_for_search]
        end
        @qmesubstation = cookies[:qmesubstation]
        @qcompany = cookies[:qcompany]
        @qregion = cookies[:qregion]
        @qfilial = cookies[:qfilial]
        @qfurnizor = cookies[:qfurnizor]
    end
    if @data_for_search.nil? or @data_for_search.empty? then
      if (@qmesubstation.nil? or @qmesubstation.empty?) and (@qcompany.nil? or @qcompany.empty?) and (@qregion.nil? or @qregion.empty?) and (@qfilial.nil? or @qfilial.empty?) and (@qfurnizor.nil? or @qfurnizor.empty?) then   
       @mp =  Vallmpoint.where(if @fpr < 6 then "filial_id = ?" else "furnizor_id = ?" end, @flr.id).order("#{sort_column} #{sort_direction}")
      else
       @filter = 1         
       @mp =  Vallmpoint.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                               "and (?='' or mesubstation_name=?) and (?='' or region_name=?) and (?='' or company_shname=?) and (?='' or filial_name=?)" +
                               " and (?='' or furnizor_name=?)", 
                               @flr.id, @qmesubstation, @qmesubstation, @qregion, @qregion, @qcompany, @qcompany, @qfilial, @qfilial, @qfurnizor, @qfurnizor).order("#{sort_column} #{sort_direction}")
      end  
    else
       @filter = 1
       @data_for_search = @data_for_search.upcase
       data_for_search = "%" + @data_for_search + "%"
       @mp =  Vallmpoint.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                               "and (upper(company_name||company_shname) like upper(?) "+ 
                               "or upper(cod||name) like upper(?) "+ 
                               "or upper(filial_name||region_name||furnizor_name) like upper(?) "+ 
                               "or upper(mesubstation_name) like upper(?)) ", 
                               @flr.id, data_for_search, data_for_search, data_for_search, data_for_search).order("#{sort_column} #{sort_direction}")
    end 
    @comps = Vallmpoint.select(:company_shname).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(company_shname: :asc).pluck(:company_shname)
    @sstations = Vallmpoint.select(:mesubstation_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(mesubstation_name: :asc).pluck(:mesubstation_name)
    @furns = if (@flr.nil? || (@fpr < 6))  then Vallmpoint.select(:furnizor_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(furnizor_name: :asc).pluck(:furnizor_name) else [[@flr.name]] end
    @fils  = if (@flr.nil? || (@fpr >= 6)) then Vallmpoint.select(:filial_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(filial_name: :asc).pluck(:filial_name)   else [[@flr.name]] end 
    @regions = Vallmpoint.select(:region_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(region_name: :asc).pluck(:region_name) 
    @page = params[:page]
    if @page.nil? then @page = 1 end 
    @mp =  @mp.paginate(:page => @page, :per_page => @perpage = $PerPage )        
  end
  
  def search
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end
    @mp =  Vallmpoint.where(if @fpr < 6 then "filial_id = ?" else "furnizor_id = ?" end, @flr.id).order("#{sort_column} #{sort_direction}") 
    @mp =  @mp.paginate(:page => params[:page], :per_page => @perpage = $PerPage )
    render "index"       
  end  
  
  def destroy
    mp = Mpoint.find(params[:mp_id])
    mt_count = mp.meters.count
    tr_count = mp.trparams.count
    ln_count = mp.lnparams.count
    if  mt_count!=0 || tr_count!=0 || ln_count!=0 then 
      flash[:warning] = "Нельзя удалить точку учета #{mp.name}: #{mp.mesubstation.name} , #{mp.clsstation}, #{mp.meconname} / #{mp.clconname}, которой принадлежат счетчики (#{mt_count} шт.), трансформаторы (#{tr_count} шт.) или линии (#{ln_count} шт.)!" 
    else 
      begin
        mp.destroy!
        flash[:notice] = "Точка учета удалена!"
      rescue
        flash[:warning] = "Не удалось удалить точку учета #{mp.name}: #{mp.mesubstation.name} / #{mp.clsstation}, #{mp.meconname} / #{mp.clconname}!" 
      end      
    end
    redirect_to company_path(:id => mp.company_id, :flr_id => params[:flr_id] )
  end  
     
private

  def filial_furnizor
    if @fpr < 6 then  @flr = @mp.first.filial else @flr =  @mp.first.furnizor end
    @furns = if (@flr.nil? || (@fpr < 6)) then Furnizor.all.pluck(:name, :id)  else [[@flr.name, @flr.id]] end
    @fils  = if (@flr.nil? || (@fpr >= 6)) then Filial.all.pluck(:name, :id)   else [[@flr.name, @flr.id]] end     
  end

  def redirect_cancel
    if params[:cancel] then
      flash.discard 
      if params[:parentform]=='newcompanympoint' then
        redirect_to companies_index_path(:id => params[:flr_id], :page => params[:page])
      else
        redirect_to company_path(:id => params[:company_id], :flag => nil, :flr_id => params[:flr_id])  
      end      
    end   
  end 
  
  def mpoint_init(mpoint)
    mpoint.cod = params[:cod]
    t = params[:name]
    t = t.lstrip
    t = t.rstrip
    mpoint.name = t
    mpoint.mesubstation_id = params[:mesubstation_id]
    mpoint.furnizor_id = params[:furnizor_id]
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
    mpoint.fct = if params[:fct].nil? then false else true end
    mpoint.fctc = if params[:fctc].nil? then nil else true end
    mpoint.fctl = if params[:fctl].nil? then nil else true end
    mpoint.four = if params[:four].nil? then nil else true end
    mpoint.fturn = if params[:fturn].nil? then nil else true end
    mpoint.fmargin = if params[:fmargin].nil? then nil else true end    
    mpoint.cosfi = params[:cosfi]      
    mpoint    
  end      
  
  def sortable_columns
    ["name", "company_shname", "furnizor_name", "filial_name", "region_name", "mesubstation_name", "cod"]
  end

  def sort_column
    sortable_columns.include?(params[:column]) ? params[:column] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end  
     
end
