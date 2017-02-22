class CompaniesController < ApplicationController
before_filter :check_user
before_filter :redirect_cancel, only: [:create, :update]    
  
  def new
  end
  
  def create
    @company = Company.new
    @company = company_init(@company)  
    begin
      @company.save! 
      flash.discard
      flash[:notice] = "Потребитель #{@company.name} сохранен." 
      if @fpr < 6 then @flr = @company.filial else @flr = @company.furnizor end
      redirect_to companies_path(:id => @flr.id,:page=>params[:page], :cp_id => @company.id)           
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'add' 
      if @fpr < 6 then @flr =  Filial.find(params[:flr_id]) else @flr =  Furnizor.find(params[:flr_id]) end
      indexview
      render "index"          
    end      
  end
  
  def update
    begin    
      @company = Company.find(params[:cp_id])
      @company = company_init(@company)
      @company.save! 
      flash.discard
      flash[:notice] = "Потребитель #{@company.name} сохранен." 
      if @fpr < 6 then @flr = @company.filial else @flr = @company.furnizor end 
      redirect_to companies_path(:id => @flr.id,:page=>params[:page], :cp_id => @company.id)               
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'edit'
      if @fpr < 6 then @flr =  Filial.find(params[:flr_id]) else @flr =  Furnizor.find(params[:flr_id]) end 
      indexview
      render "index"       
    end  
  end  

  def edit
    @flag = 'edit'
    @company = Company.find(params[:cp_id])
    flash.discard
    if @fpr < 6 then @flr =  Filial.find(params[:flr_id]) else @flr =  Furnizor.find(params[:flr_id]) end 
    indexview
    render "index"  
  end

  def index
    if params[:cp_id].nil? then
      @company = Company.new
    else
      @company = Company.find(params[:cp_id])
      params[:cp_id] = nil
    end  
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end 
    indexview            
  end
  
  def show     
    @cp =  Company.find(params[:id])
    if @fpr < 6 then  @flr = @cp.filial else @flr =  @cp.furnizor end 
    @mpoint = @cp.mpoints.build
    @mp =  @cp.mpoints.order(name: :asc, created_at: :asc) 
    @mp =  @mp.paginate(:page => params[:page], :per_page => @perpage = $PerPage )  
  end

  def destroy
    begin    
      cp = Company.find(params[:cp_id])
      mp_count = cp.mpoints.count
      if  mp_count!=0 then 
        flash[:warning] = "Нельзя потребителя #{cp.name}, которому принадлежат точки учета (#{mp_count} шт.)!" 
      else 
        cp.destroy!
        flash[:notice] = "Потребитель  #{cp.name} удален!"
      end          
    rescue
      flash[:warning] = "Не удалось удалить потребителя #{cp.name}!"     
    end
    redirect_to companies_path(:id => params[:flr_id],:page=>params[:page]) 
  end    

  def mvreport
    @page = params[:page]
    @page1 = params[:page1]
    @id = params[:cp_id]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr = @cp.filial else @flr =  @cp.furnizor end
    @ddate_b = Date.new(2000, 1, 1)  
    @ddate_e = Date.new(3000, 1, 1)   
    @mvalues = Vmpointsmetersvalue.where("company_id = ? AND (actdate between ? AND  ?)", @id, @ddate_b, @ddate_e).order(:id, :meter_id, :actdate, :mvalue_updated_at)
    if @mvalues.count != 0
      @mvalues = @mvalues.paginate(:page => @page, :per_page => $PerPage*2 )
    end    
  end  
 
  def report
    @page = params[:page]
    @id = params[:cp_id]
    @month_for_report = params[:month_for_report]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr = @cp.filial else @flr =  @cp.furnizor end
    # month   
    if @month_for_report.nil? then @ddate = Date.current else @ddate = Date.strptime(@month_for_report, '%Y-%m') end
    @luna = $Luni[@ddate.month.to_i-1]
    @ddate_b = @ddate.change(day: 1)-1.month  
    @ddate_e = @ddate.change(day: 1)+1.month-1.day    
    @luna_b = $Luni[@ddate_b.month.to_i-1] + ' ' + @ddate_b.year.to_s
    @luna_e = $Luni[@ddate_e.month.to_i-1] + ' ' + @ddate_e.year.to_s
    # report init
    @report = Array[]
    nr = 1
    # mpoints
    @mpoints = @cp.mpoints.where(f: 'true').order(:name,:id)
    if @mpoints.count == 0 then
      flash[:warning] = "Нет данных для отчета. Потребитель не имеет точек учета." 
    else
      @mpoints.each do |item| 
        report_trind = [nr,"#{item.name} #{item.messtation}","#{item.meconname}","#{item.clconname}",nil,nil,nil,nil,nil,nil,nil,nil]
        nr += 1               
      # mvalues = Vmetersvalue.where("mpoint_id = ? AND (actdate between ? AND  ?)", item.id, @ddate_b, @ddate_e).order(:actdate, :mvalue_updated_at)
        @mvalues = Vmpointsmetersvalue.where("id = ? AND (actdate between ? AND  ?)", item.id, @ddate_b, @ddate_e).order(:meter_id,:actdate, :mvalue_updated_at)
        if @mvalues.count == 0 then
          report_trind[10] = 1
          @report << report_trind[0..10]
        else
          @report << report_trind[0..10] 
        end
      end
    end
  end
  
  def report1
    @page = params[:page]
    @cp = Company.find(params[:cp_id])
    if @fpr < 6 then  @flr = @cp.filial else @flr =  @cp.furnizor end 
    @id = params[:cp_id]
#    @mp = @cp.mpoints.all.order(:messtation, :meconname, :clsstation, :clconname)
    @mp = @cp.mpoints.where(f: 'true').order(:name,:id)
    @month_for_report = (params[:month_for_report])
    if (params[:month_for_report]).nil? then @ddate = Date.current else @ddate = Date.strptime(params[:month_for_report], '%Y-%m') end
    luni = ['ianuarie','februarie','martie','aprilie','mai','iunie','iulie','august','septembrie','octombrie','noiembrie','decembrie']  
    @luna = luni[@ddate.month.to_i-1]                               
    @ddateb1 = Date.new(2000, 1, 1)
 #   @ddateb1 = @ddate.change(day: 1)-1.month  
    @ddateb2 = @ddate.change(day: 1)-1.day
    @ddatee1 = Date.new(2000, 1, 1)
 #   @ddatee1 = @ddate.change(day: 1)  
    @ddatee2 = @ddate.change(day: 1)+1.month-1.day
    @luna0 = luni[@ddateb2.month.to_i-1] + ' ' + @ddateb2.year.to_s
    @luna1 = luni[@ddatee2.month.to_i-1] + ' ' + @ddatee2.year.to_s
    j=0
    sumaapr = 0.0
    sumaaliv = 0.0
    trlosses = 0.0 
    lnlosses = 0.0
    consumteh = 0.0 
    #report_rind = Array[]
    report_rind = [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
    @report = Array[]
    @mp.each do |item|
      j = j+1
      report_rind[0] = j    
      report_rind[1] = "#{item.messtation} (#{item.clsstation})"
      report_rind[2] = "#{item.meconname} (#{item.clconname})"
      report_rind[3] = "#{item.clconname}"
      @met = item.meters.first
      @tr  = item.trparams.where("f = 'true'")
      @ln  = item.lnparams.where("f = 'true'")
      if @met.nil? then
        @report <<  [report_rind[0],report_rind[1],nil,nil,nil,nil,nil,nil,nil,nil,1]           
      else  
        @ddatemv0 = nil 
        @ddatemv1 = nil
        report_rind[4] = @met.meternum        
        if @met.koefcalc.nil? then report_rind[8] = 1.to_i else report_rind[8] = @met.koefcalc.to_i end    
        # 1.8.0
        s = indicii('actp180', report_rind[8])          
        # title date
        # дата съема
        if (!@ddatemv0.nil? and !@ddatemv1.nil?) then dt = (@ddatemv0 - @ddatemv1).to_i else dt=0 end 
        @report << [report_rind[0],report_rind[1],report_rind[2]+' дата съема',report_rind[3],report_rind[4],
                       unless @ddatemv0.nil? then @ddatemv0.to_formatted_s(:day_month_year) end,
                       unless @ddatemv1.nil? then @ddatemv1.to_formatted_s(:day_month_year) end,dt,nil,nil,s[:color]]      
        # 1.8.0
        wapr = s[:energy]
        sumaapr += s[:energy]           
        @report << [nil,nil,report_rind[2]+' a/pr',nil,nil,s[:ind0],s[:ind1],s[:dind],report_rind[8],s[:energy],s[:color]]      
        # 2.8.0
        s = indicii('actp280', report_rind[8]) 
        waliv = s[:energy]
        sumaaliv +=  s[:energy]    
        @report << [nil,nil,report_rind[2]+' a/liv',nil,nil,s[:ind0],s[:ind1],s[:dind],report_rind[8],s[:energy],s[:color]]      
        # 3.8.0 
        s = indicii('actp380', report_rind[8]) 
        wrpr = s[:energy]  
        @report << [nil,nil,report_rind[2]+' r/pr',nil,nil,s[:ind0],s[:ind1],s[:dind],report_rind[8],s[:energy],s[:color]]      
        # 4.8.0
        s = indicii('actp480', report_rind[8]) 
        wrliv = s[:energy] 
        @report << [nil,nil,report_rind[2]+' r/liv',nil,nil,s[:ind0],s[:ind1],s[:dind],report_rind[8],s[:energy],s[:color]]      
        # косинус фи 
        if (wapr ** 2 + wrpr ** 2)!=0 then 
           cosfi = ((wapr ** 2 / (wapr ** 2 + wrpr ** 2))  ** 0.5).round 4 
           @report << [nil,'cos fi /pr',nil,nil,nil,nil,nil,nil,nil,cosfi,nil]         
        end
        if (waliv ** 2 + wrliv ** 2)!=0 then       
           cosfi2 = ((waliv ** 2 / (waliv ** 2 + wrliv ** 2))  ** 0.5).round 4          
           @report << [nil,'cos fi /liv',nil,nil,nil,nil,nil,nil,nil,cosfi2,nil]       
        end 
        # трансформаторы
        tr_losses_xx = 0.0
        tr_losses_kz = 0.0
        if !@tr.nil? then
          @tr.each do |tritem|
            tr_losses_xx += dt * 24 * tritem.pxx.to_f
            case when wapr.to_f <= 0.9 * 167 * cosfi.to_f * (tritem.snom.to_f) then 
                      tau = 77
                      tm = 167 
                 when wapr.to_f <= 0.9 * 333 * cosfi.to_f * (tritem.snom.to_f) then 
                      tau = 200
                      tm = 333
                 when wapr.to_f <= 0.9 * 500 * cosfi.to_f * (tritem.snom.to_f) then
                      tau = 383
                      tm = 500
                 when wapr.to_f <= 0.9 * 667 * cosfi.to_f * (tritem.snom.to_f) then 
                      tau = 623
                      tm = 667
                 when wapr.to_f <= 0.9 * 730 * cosfi.to_f * (tritem.snom.to_f) then 
                      tau = 730
                      tm = 730  
                 else tau = 730
                      tm = 730    
            end
            if (dt!=0 and tritem.snom.to_f!=0) then tr_losses_kz += tritem.pkz.to_f * tau * (wapr ** 2 + wrpr ** 2) / ( (tm ** 2) * ((tritem.snom.to_f) ** 2) ) end
          end
          # линии
          ln_losses_ng = 0.0
          ln_losses_kr = 0.0
          if !@ln.nil? then
             rk = 0.0
             @ln.each do |lnitem|
               rk += lnitem.r.to_f * (lnitem.k_f.to_f ** 2)
             end
             if (dt!=0 and item.voltcl.to_f!=0) then ln_losses_ng = rk * (wapr ** 2 + wrpr ** 2) / (1000 * ((item.voltcl.to_f) ** 2) * dt * 24) end
          end     
        end
        tr_losses_xx = tr_losses_xx.round 4
        tr_losses_kz = tr_losses_kz.round 4
        ln_losses_ng = ln_losses_ng.round 4
        ln_losses_kr = ln_losses_kr.round 4
        trlosses += tr_losses_xx
        trlosses += tr_losses_kz
        lnlosses += ln_losses_ng
        lnlosses += ln_losses_kr
        @report << [nil,'Потери тр-ра хол ход',nil,nil,nil,nil,nil,nil,nil,tr_losses_xx,nil]                
        @report << [nil,'Потери тр-ра КЗ',nil,nil,nil,nil,nil,nil,nil,tr_losses_kz,nil] 
        @report << [nil,'Потери тр-ра суммарные',nil,nil,nil,nil,nil,nil,nil,((tr_losses_kz+tr_losses_xx).round 2),2] 
        @report << [nil,'Потери ВЛ нагрузочные',nil,nil,nil,nil,nil,nil,nil,ln_losses_ng,nil]               
        @report << [nil,'Потери ВЛ на корону',nil,nil,nil,nil,nil,nil,nil,ln_losses_kr,nil] 
        @report << [nil,'Потери ВЛ суммарные',nil,nil,nil,nil,nil,nil,nil,((ln_losses_ng+ln_losses_kr).round 2),2] 
      end  
    end
    @report << [nil,'Потери в линии',nil,nil,nil,nil,nil,nil,nil,(lnlosses.round 2),3]      
    @report << [nil,'Потери в трансформаторах',nil,nil,nil,nil,nil,nil,nil,(trlosses.round 2),3]      
    @report << [nil,'Consum tehnologic',nil,nil,nil,nil,nil,nil,nil,(consumteh.round 2),nil]      
    @report << [nil,'Сумма a/pr',nil,nil,nil,nil,nil,nil,nil,(sumaapr.round 2),4]       
    @report << [nil,'Сумма a/liv',nil,nil,nil,nil,nil,nil,nil,(sumaaliv.round 2),4]       
    respond_to do |format|
      format.html
      format.pdf { send_data ListaReport.new.to_pdf(@cp,@report,@luna,@ddate,@luna1,@luna0), :type => 'application/pdf', :filename => "lista.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="lista.xlsx"' }
    end                         
  end  
  
private 
 
  def indicii(cname='actp180',koef=1)
    mv1 = Vmetersvalue.where("id = ? AND (#{cname} IS NOT NULL) AND (actdate between ? AND  ?)", @met.id, @ddateb1, @ddateb2).order(:actdate, :mvalue_updated_at).last
    mv0 = Vmetersvalue.where("id = ? AND (#{cname} IS NOT NULL) AND (actdate between ? AND  ?)", @met.id, @ddatee1, @ddatee2).order(:actdate, :mvalue_updated_at).last    
 #   mv1 = Mvalue.where("meter_id = ? AND (#{cname} IS NOT NULL) AND (actdate between ? AND  ?)", @met.id, @ddateb1, @ddateb2).order(:actdate, :created_at, :updated_at).last
 #   mv0 = Mvalue.where("meter_id = ? AND (#{cname} IS NOT NULL) AND (actdate between ? AND  ?)", @met.id, @ddatee1, @ddatee2).order(:actdate, :created_at, :updated_at).last
    ind0 = 0 
    ind1 = 0
    color = nil
    if !mv0.nil? then 
        case when cname=='actp180' then ind0 = mv0.actp180
             when cname=='actp280' then ind0 = mv0.actp280
             when cname=='actp380' then ind0 = mv0.actp380
             when cname=='actp480' then ind0 = mv0.actp480    
        end
        if (@ddatemv0.nil?) || (@ddatemv0 < mv0.actdate) then @ddatemv0 = mv0.actdate end
        if  mv0.actdate < @ddatee2.change(day: 1) then color=1 end     
    end       
    if !mv1.nil? then 
        case when cname=='actp180' then ind1 = mv1.actp180
             when cname=='actp280' then ind1 = mv1.actp280
             when cname=='actp380' then ind1 = mv1.actp380
             when cname=='actp480' then ind1 = mv1.actp480    
        end
        if (@ddatemv1.nil?) || (@ddatemv1 < mv1.actdate) then !@ddatemv1 = mv1.actdate end 
        if  mv1.actdate < @ddateb2.change(day: 1) then color=1 end         
    end
    dind = (ind0 - ind1).round 4            
    energy = (dind * koef).round 4
    return({:ind0 => ind0, :ind1 => ind1, :dind => dind, :energy => energy, :color => color})    
  end
  
   def indexview
    @companies = @flr.companys.all.order(name: :asc)
    @page = params[:page] 
    if !@company.nil? && !@company.id.nil? then 
      i = 0
      n = 0
      @companies.each do |item|
        if item.id == @company.id then n = i end
        i += 1   
      end
      @page = (n / $PerPage + 0.5).round       
    end  
    if @page.nil? then 
      @page = 1
    elsif !@companies.nil? &&  @companies.count < (@page.to_i - 1) * $PerPage then 
      @page = ((@companies.count-1) / $PerPage + 0.5).round    
    end  
    unless @companies.nil? then @companies = @companies.paginate(:page => @page, :per_page => $PerPage ) end               
  end  
 
  def redirect_cancel
    if params[:cancel] then
      flash.discard
      redirect_to companies_path(:id => params[:flr_id], :page => @page)     
    end   
  end
      
  def company_init(company)
    t = params[:name]
    t = t.lstrip
    t = t.rstrip
    company.name = t
    t1 = params[:shname]
    t1 = t1.lstrip
    t1 = t1.rstrip 
    if t1.size == 0 then t1 = t[0,14] end      
    company.shname = t1
    t = params[:region]
    t = t.lstrip
    t = t.rstrip     
    company.region = t 
    company.furnizor_id = (params[:furnizor_id]).to_i  
    company.filial_id = (params[:filial_id]).to_i
    t = params[:comment]
    t = t.lstrip
    t = t.rstrip   
    company.comment = t
    company.f = if params[:f].nil? then false else true end  
    company    
  end        
     
end
