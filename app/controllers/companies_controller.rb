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
 
   def mtreport
    @page = params[:page]
    @id = params[:cp_id]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr = @cp.filial else @flr =  @cp.furnizor end 
    @meters = Vmpointsmeter.where("company_id = ?", @id).order(:name, :id, :relevance_date, :updated_at)   
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
    nr = 0
    cp_enrgsums = [ 0.0, 0.0, 0.0, 0.0]
    trlosses = 0.0 
    lnlosses = 0.0
    consumteh = 0.0 
    # mpoints 
    @mpoints = @cp.mpoints.where(f: 'true').order(:name,:id)
    if @mpoints.count == 0 then
      flash[:warning] = "Нет данных для отчета. Потребитель не имеет точек учета." 
    else
      @mpoints.each do |item| 
        @result = nil #one_mp_losses(item.id,@ddate_b,@ddate_e)
        taus = Tau.all
        mvnum = 0
        dtsum = 0
        mp_enrgsums = [ 0.0, 0.0, 0.0, 0.0]
        nr += 1  
        report_rind = [nr,"#{item.name} #{item.messtation}","#{item.meconname}","#{item.clconname}",nil,nil,nil,nil,nil,nil,nil,nil]     
        meters = Vmpointsmeter.where("id = ? AND ((? between relevance_date AND relevance_end) OR (? between relevance_date AND relevance_end))", item.id, @ddate_b, @ddate_e).order(:meter_id)
        if meters.count == 0 then
           flash[:warning] = "У точки учета #{item.name} нет счетчиков!" 
           report_rind[10] = 1
           @report << report_rind[0..10]          
        else  
          meters.each do |mitem| 
            report_rind[10] = nil
            report_rind[4] = mitem.meternum      
            @mvalues = Vmpointsmetersvalue.where("id = ? AND meter_id = ? AND (actdate between ? AND  ?)", item.id, mitem.meter_id,@ddate_b, @ddate_e).order(:actdate, :mvalue_updated_at)
            if @mvalues.count == 0 then
              report_rind[10] = 1
              @report << report_rind[0..10]
            else
              if @mvalues.count == 1 then report_rind[10] = 1 else mvnum = 2 end
              mvalue0 = @mvalues.first
              mvalue1 = @mvalues.last               
              date1 = mvalue1.actdate              
              date0 = mvalue0.actdate
              dt = report_rind[7] = (date1 - date0).to_i
              dtsum += dt 
              report_rind[5] = date1.to_formatted_s(:day_month_year)
              report_rind[6] = date0.to_formatted_s(:day_month_year)  
              @report << report_rind[0..10]
              report_rind[0..4] = [nil,nil,nil,nil,nil]
              koef = report_rind[8] = mitem.koefcalc 
              ind1 = report_rind[5] = mvalue1.actp180
              ind0 = report_rind[6] = mvalue0.actp180
              dind = report_rind[7] = (ind1 - ind0).round(4)            
              energy = report_rind[9] = (dind * koef).round(4)
              mp_enrgsums[0] += energy
              report_rind[2] = ' a/pr'
              @report << report_rind[0..10]
              ind1 = report_rind[5] = mvalue1.actp280
              ind0 = report_rind[6] = mvalue0.actp280
              dind = report_rind[7] = (ind1 - ind0).round(4)            
              energy = report_rind[9] = (dind * koef).round(4)
              mp_enrgsums[1] += energy
              report_rind[2] = ' a/liv'              
              @report << report_rind[0..10] 
              ind1 = report_rind[5] = mvalue1.actp380
              ind0 = report_rind[6] = mvalue0.actp380
              dind = report_rind[7] = (ind1 - ind0).round(4)            
              energy = report_rind[9] = (dind * koef).round(4)
              mp_enrgsums[2] += energy
              report_rind[2] = ' r/pr'              
              @report << report_rind[0..10]
              ind1 = report_rind[5] = mvalue1.actp480
              ind0 = report_rind[6] = mvalue0.actp480
              dind = report_rind[7] = (ind1 - ind0).round(4)            
              energy = report_rind[9] = (dind * koef).round(4)
              mp_enrgsums[3] += energy
              report_rind[2] = ' r/liv'              
              @report << report_rind[0..10] 
              report_rind[2] = report_rind[8] = report_rind[9] = nil            
            end # if mvalues.count
          end  # meters.each
          if mvnum == 2 then
            # энергии
            @report << [nil,'Energie a/pr',nil,nil,nil,nil,nil,nil,nil,mp_enrgsums[0],nil]
            @report << [nil,'Energie a/liv',nil,nil,nil,nil,nil,nil,nil,mp_enrgsums[1],nil]
            @report << [nil,'Energie r/pr',nil,nil,nil,nil,nil,nil,nil,mp_enrgsums[2],nil]
            @report << [nil,'Energie r/liv',nil,nil,nil,nil,nil,nil,nil,mp_enrgsums[3],nil]    
            # косинус фи 
            if mp_enrgsums[0] != 0 || mp_enrgsums[2] != 0 then 
              cosfi = ((mp_enrgsums[0] ** 2 / (mp_enrgsums[0] ** 2 + mp_enrgsums[2] ** 2)) ** 0.5).round(4) 
              @report << [nil,'cos fi /pr',nil,nil,nil,nil,nil,nil,nil,cosfi,nil]         
            end 
            # трансформаторы
            tr  = item.trparams.where("f = 'true'")
            tr_losses_xx = tr_losses_kz = tr_losses_rxx = tr_losses_rkz = 0.0
            if tr.count == 0 then
              flash[:warning] = "У точки учета #{item.name} нет трансформаторов!" 
            elsif  dtsum != 0 then 
              tr.each do |tritem|
                tr_losses_xx += dtsum * 24 * tritem.pxx
                tau = taus.last.taum
                tm = taus.last.tm 
                taus.each do |itau|
                  if mp_enrgsums[0] <= 0.9 * itau.tm * cosfi * (tritem.snom) then 
                       tau = itau.taum
                       tm = itau.tm
                       break                       
                  end
                end
                if tritem.snom == 0 then
                  flash[:warning] = "Невозможно рассчитать потери КЗ тр-ра для #{item.name}, т.к. Snom = 0 !"                   
                else  
                  tr_losses_kz += tritem.pkz * tau * (mp_enrgsums[0] ** 2 + mp_enrgsums[2] ** 2) / ((tm ** 2) * ((tritem.snom) ** 2))
                  tr_losses_rkz += tritem.qkz * tau * (mp_enrgsums[0] ** 2 + mp_enrgsums[2] ** 2) / ((tm ** 2) * ((tritem.snom) ** 2))
                end
                tr_losses_rxx += (((tritem.io ** 2) * (tritem.snom ** 2) / 10000 - tritem.pxx ** 2) ** 0.5) * dtsum * 24
              end  # tr.each
              tr_losses_xx = tr_losses_xx.round(4)
              tr_losses_kz = tr_losses_kz.round(4)
              tr_losses_rxx = tr_losses_rxx.round(4)
              tr_losses_rkz = tr_losses_rkz.round(4)
              trlosses += tr_losses_xx
              trlosses += tr_losses_kz
              @report << [nil,'Потери тр-ра Pxx',nil,nil,nil,nil,nil,nil,nil,tr_losses_xx,nil]                
              @report << [nil,'Потери тр-ра Pкз',nil,nil,nil,nil,nil,nil,nil,tr_losses_kz,nil]
              @report << [nil,'Потери тр-ра P суммарные',nil,nil,nil,nil,nil,nil,nil,(tr_losses_kz+tr_losses_xx).round(4),2] 
              @report << [nil,'Потери тр-ра Rxx',nil,nil,nil,nil,nil,nil,nil,tr_losses_rxx,nil] 
              @report << [nil,'Потери тр-ра Rкз',nil,nil,nil,nil,nil,nil,nil,tr_losses_rkz,nil]
              @report << [nil,'Потери тр-ра R суммарные',nil,nil,nil,nil,nil,nil,nil,(tr_losses_rkz+tr_losses_rxx).round(4),2]                
            end  # if tr.count
            # линии              
            ln  = item.lnparams.where("f = 'true'") 
            ln_losses_ng = ln_losses_kr = 0.0        
            if ln.count == 0 then
              flash[:warning] = "У точки учета #{item.name} нет линий!"  
            elsif dtsum != 0 then
              if item.voltcl == 0 then
                flash[:warning] = "Невозможно рассчитать потери в линии для #{item.name}, т.к. voltcl = 0 !" 
              else               
                rk = 0.0
                ln.each do |lnitem|
                  rk += lnitem.r * (lnitem.k_f ** 2)
                end
                ln_losses_ng = ( rk * (mp_enrgsums[0] ** 2 + mp_enrgsums[2] ** 2) / (1000 * ((item.voltcl) ** 2) * dtsum * 24) ).round(4)
                ln_losses_kr = ln_losses_kr.round(4)
                lnlosses += ln_losses_ng
                lnlosses += ln_losses_kr                
                @report << [nil,'Потери ВЛ нагрузочные',nil,nil,nil,nil,nil,nil,nil,ln_losses_ng,nil]               
                @report << [nil,'Потери ВЛ на корону',nil,nil,nil,nil,nil,nil,nil,ln_losses_kr,nil] 
                @report << [nil,'Потери ВЛ суммарные',nil,nil,nil,nil,nil,nil,nil,(ln_losses_ng+ln_losses_kr).round(4),2] 
              end
            end  # if ln.count
            # cos fi with losses
            ct = 0.0             
            if mp_enrgsums[0] >= 10000 then
               wa = mp_enrgsums[0] + tr_losses_kz + tr_losses_xx + ln_losses_ng + ln_losses_kr
               wr = mp_enrgsums[2] + tr_losses_rkz + tr_losses_rxx
               cosf = wa / ((wa ** 2 + wr ** 2) ** 0.5)
               wrio = wa * 0.567
               if wrio < mp_enrgsums[2] then
                 wrif = mp_enrgsums[2] - wrio
               else
                 wrif = 0.0
               end
               ct = ((mp_enrgsums[3] + wrif ) * 0.1).round(4)
               consumteh += ct
               @report << [nil,'Технологический расход',nil,nil,nil,nil,nil,nil,nil,ct,2]   
            end
            # energy sums
            cp_enrgsums[0] += mp_enrgsums[0]
            cp_enrgsums[1] += mp_enrgsums[1]
            cp_enrgsums[2] += mp_enrgsums[2]
            cp_enrgsums[3] += mp_enrgsums[3]                  
          end # if mvnum
        end # if meters.count    
      end  # mpoint.each
    @report << ['∑','Итого Energie a/pr',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[0],4]       
    @report << ['∑','Итого Energie a/liv',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[1],4]
    @report << ['∑','Итого Energie r/pr',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[2],4]       
    @report << ['∑','Итого Energie r/liv',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[3],4]            
    @report << ['∑','Итого Потери в трансформаторах',nil,nil,nil,nil,nil,nil,nil,trlosses,3]
    @report << ['∑','Итого Потери ВЛ',nil,nil,nil,nil,nil,nil,nil,lnlosses,3]
    @report << ['∑','Итого Потери в трансформаторах и ВЛ',nil,nil,nil,nil,nil,nil,nil,trlosses+lnlosses,3]  
    @report << ['∑','Итого Consum tehnologic',nil,nil,nil,nil,nil,nil,nil,consumteh,nil]            
    end  # if mpoint.count
    respond_to do |format|
      format.html
      format.pdf { send_data ListaReport.new.to_pdf(@cp,@report,@luna,@ddate,@luna_b,@luna_e), :type => 'application/pdf', :filename => "lista.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="lista.xlsx"' }
    end      
  end
  
private 

  def one_mp_losses(mp_id,ddate_b,ddate_e)
    mpoint = Mpoint.find(mp_id)
    mp_enrgsums = [ 0.0, 0.0, 0.0, 0.0]       
    taus = Tau.all
    mvnum = 0
    dtsum = 0  
    meters = Vmpointsmeter.where("id = ? AND ((? between relevance_date AND relevance_end) OR (? between relevance_date AND relevance_end))", mp_id, ddate_b, ddate_e).order(:meter_id)
    if meters.count == 0 then
       flash[:warning] = "У точки учета #{item.name} нет счетчиков!"          
    else  
       meters.each do |mitem| 
         report_rind[4] = mitem.meternum      
         @mvalues = Vmpointsmetersvalue.where("id = ? AND meter_id = ? AND (actdate between ? AND  ?)", item.id, mitem.meter_id,@ddate_b, @ddate_e).order(:actdate, :mvalue_updated_at)
         if @mvalues.count != 0 then
              if @mvalues.count == 1 then report_rind[10] = 1 else mvnum = 2 end
              mvalue0 = @mvalues.first
              mvalue1 = @mvalues.last               
              date1 = mvalue1.actdate              
              date0 = mvalue0.actdate
              dt = report_rind[7] = (date1 - date0).to_i
              dtsum += dt 
              report_rind[5] = date1.to_formatted_s(:day_month_year)
              report_rind[6] = date0.to_formatted_s(:day_month_year)  
              @report << report_rind[0..10]
              report_rind[0..4] = [nil,nil,nil,nil,nil]
              koef = report_rind[8] = mitem.koefcalc 
              ind1 = report_rind[5] = mvalue1.actp180
              ind0 = report_rind[6] = mvalue0.actp180
              dind = report_rind[7] = (ind1 - ind0).round(4)            
              energy = report_rind[9] = (dind * koef).round(4)
              mp_enrgsums[0] += energy
              report_rind[2] = ' a/pr'
              @report << report_rind[0..10]
              ind1 = report_rind[5] = mvalue1.actp280
              ind0 = report_rind[6] = mvalue0.actp280
              dind = report_rind[7] = (ind1 - ind0).round(4)            
              energy = report_rind[9] = (dind * koef).round(4)
              mp_enrgsums[1] += energy
              report_rind[2] = ' a/liv'              
              @report << report_rind[0..10] 
              ind1 = report_rind[5] = mvalue1.actp380
              ind0 = report_rind[6] = mvalue0.actp380
              dind = report_rind[7] = (ind1 - ind0).round(4)            
              energy = report_rind[9] = (dind * koef).round(4)
              mp_enrgsums[2] += energy
              report_rind[2] = ' r/pr'              
              @report << report_rind[0..10]
              ind1 = report_rind[5] = mvalue1.actp480
              ind0 = report_rind[6] = mvalue0.actp480
              dind = report_rind[7] = (ind1 - ind0).round(4)            
              energy = report_rind[9] = (dind * koef).round(4)
              mp_enrgsums[3] += energy
              report_rind[2] = ' r/liv'              
              @report << report_rind[0..10] 
              report_rind[2] = report_rind[8] = report_rind[9] = nil            
            end # if mvalues.count
          end  # meters.each
          if mvnum == 2 then
            # энергии
            @report << [nil,'Energie a/pr',nil,nil,nil,nil,nil,nil,nil,mp_enrgsums[0],nil]
            @report << [nil,'Energie a/liv',nil,nil,nil,nil,nil,nil,nil,mp_enrgsums[1],nil]
            @report << [nil,'Energie r/pr',nil,nil,nil,nil,nil,nil,nil,mp_enrgsums[2],nil]
            @report << [nil,'Energie r/liv',nil,nil,nil,nil,nil,nil,nil,mp_enrgsums[3],nil]    
            # косинус фи 
            if mp_enrgsums[0] != 0 || mp_enrgsums[2] != 0 then 
              cosfi = ((mp_enrgsums[0] ** 2 / (mp_enrgsums[0] ** 2 + mp_enrgsums[2] ** 2)) ** 0.5).round(4) 
              @report << [nil,'cos fi /pr',nil,nil,nil,nil,nil,nil,nil,cosfi,nil]         
            end 
            # трансформаторы
            tr  = item.trparams.where("f = 'true'")
            tr_losses_xx = tr_losses_kz = tr_losses_rxx = tr_losses_rkz = 0.0
            if tr.count == 0 then
              flash[:warning] = "У точки учета #{item.name} нет трансформаторов!" 
            elsif  dtsum != 0 then 
              tr.each do |tritem|
                tr_losses_xx += dtsum * 24 * tritem.pxx
                tau = taus.last.taum
                tm = taus.last.tm 
                taus.each do |itau|
                  if mp_enrgsums[0] <= 0.9 * itau.tm * cosfi * (tritem.snom) then 
                       tau = itau.taum
                       tm = itau.tm
                       break                       
                  end
                end
                if tritem.snom == 0 then
                  flash[:warning] = "Невозможно рассчитать потери КЗ тр-ра для #{item.name}, т.к. Snom = 0 !"                   
                else  
                  tr_losses_kz += tritem.pkz * tau * (mp_enrgsums[0] ** 2 + mp_enrgsums[2] ** 2) / ((tm ** 2) * ((tritem.snom) ** 2))
                  tr_losses_rkz += tritem.qkz * tau * (mp_enrgsums[0] ** 2 + mp_enrgsums[2] ** 2) / ((tm ** 2) * ((tritem.snom) ** 2))
                end
                tr_losses_rxx += (((tritem.io ** 2) * (tritem.snom ** 2) / 10000 - tritem.pxx ** 2) ** 0.5) * dtsum * 24
              end  # tr.each
              tr_losses_xx = tr_losses_xx.round(4)
              tr_losses_kz = tr_losses_kz.round(4)
              tr_losses_rxx = tr_losses_rxx.round(4)
              tr_losses_rkz = tr_losses_rkz.round(4)
              trlosses += tr_losses_xx
              trlosses += tr_losses_kz
              @report << [nil,'Потери тр-ра Pxx',nil,nil,nil,nil,nil,nil,nil,tr_losses_xx,nil]                
              @report << [nil,'Потери тр-ра Pкз',nil,nil,nil,nil,nil,nil,nil,tr_losses_kz,nil]
              @report << [nil,'Потери тр-ра P суммарные',nil,nil,nil,nil,nil,nil,nil,(tr_losses_kz+tr_losses_xx).round(4),2] 
              @report << [nil,'Потери тр-ра Rxx',nil,nil,nil,nil,nil,nil,nil,tr_losses_rxx,nil] 
              @report << [nil,'Потери тр-ра Rкз',nil,nil,nil,nil,nil,nil,nil,tr_losses_rkz,nil]
              @report << [nil,'Потери тр-ра R суммарные',nil,nil,nil,nil,nil,nil,nil,(tr_losses_rkz+tr_losses_rxx).round(4),2]                
            end  # if tr.count
            # линии              
            ln  = item.lnparams.where("f = 'true'") 
            ln_losses_ng = ln_losses_kr = 0.0        
            if ln.count == 0 then
              flash[:warning] = "У точки учета #{item.name} нет линий!"  
            elsif dtsum != 0 then
              if item.voltcl == 0 then
                flash[:warning] = "Невозможно рассчитать потери в линии для #{item.name}, т.к. voltcl = 0 !" 
              else               
                rk = 0.0
                ln.each do |lnitem|
                  rk += lnitem.r * (lnitem.k_f ** 2)
                end
                ln_losses_ng = ( rk * (mp_enrgsums[0] ** 2 + mp_enrgsums[2] ** 2) / (1000 * ((item.voltcl) ** 2) * dtsum * 24) ).round(4)
                ln_losses_kr = ln_losses_kr.round(4)
                lnlosses += ln_losses_ng
                lnlosses += ln_losses_kr                
                @report << [nil,'Потери ВЛ нагрузочные',nil,nil,nil,nil,nil,nil,nil,ln_losses_ng,nil]               
                @report << [nil,'Потери ВЛ на корону',nil,nil,nil,nil,nil,nil,nil,ln_losses_kr,nil] 
                @report << [nil,'Потери ВЛ суммарные',nil,nil,nil,nil,nil,nil,nil,(ln_losses_ng+ln_losses_kr).round(4),2] 
              end
            end  # if ln.count
            # cos fi with losses
            ct = 0.0             
            if mp_enrgsums[0] >= 10000 then
               wa = mp_enrgsums[0] + tr_losses_kz + tr_losses_xx + ln_losses_ng + ln_losses_kr
               wr = mp_enrgsums[2] + tr_losses_rkz + tr_losses_rxx
               cosf = wa / ((wa ** 2 + wr ** 2) ** 0.5)
               wrio = wa * 0.567
               if wrio < mp_enrgsums[2] then
                 wrif = mp_enrgsums[2] - wrio
               else
                 wrif = 0.0
               end
               ct = ((mp_enrgsums[3] + wrif ) * 0.1).round(4)
               consumteh += ct
               @report << [nil,'Технологический расход',nil,nil,nil,nil,nil,nil,nil,ct,2]   
            end
            # energy sums
            cp_enrgsums[0] += mp_enrgsums[0]
            cp_enrgsums[1] += mp_enrgsums[1]
            cp_enrgsums[2] += mp_enrgsums[2]
            cp_enrgsums[3] += mp_enrgsums[3]                  
          end # if mvnum
     end # if meters.count    
     {:consumteh => ct}
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
