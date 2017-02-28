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
        nr += 1  
        report_rind = [nr,"#{item.name} #{item.messtation}","#{item.meconname}","#{item.clconname}", nil, nil, nil, nil, nil, nil, nil, nil] 
        # indicii si energie        
        energies = one_mp_indicii(item.id, @ddate_b, @ddate_e)
        indicii = energies[:indicii]
        if indicii.nil? or indicii.count==0 then
          report_rind[10] = 1
          @report << report_rind[0..10]
        else  
          indicii.each do |inditem|
            report_rind[10] = 1
            unless inditem[:meternum].nil? then report_rind[4] = inditem[:meternum] end
            unless inditem[:date1].nil? then 
              report_rind[5] = (inditem[:date1]).to_formatted_s(:day_month_year)
              report_rind[10] = nil 
            end  
            unless inditem[:date0].nil? then report_rind[6] = (inditem[:date0]).to_formatted_s(:day_month_year) end
            unless inditem[:dt].nil? then report_rind[7] = inditem[:dt] end     
            @report << report_rind[0..10]
            report_rind[0..4] = [nil,nil,nil,nil,nil]
            unless inditem[:date1].nil? then
              @report << [nil,nil,'a/pr',nil,nil,inditem[:ind1_180],inditem[:ind0_180],inditem[:dind_180],inditem[:koef],inditem[:enrg_180],nil]
              @report << [nil,nil,'a/liv',nil,nil,inditem[:ind1_280],inditem[:ind0_280],inditem[:dind_280],inditem[:koef],inditem[:enrg_280],nil]
              @report << [nil,nil,'r/pr',nil,nil,inditem[:ind1_380],inditem[:ind0_380],inditem[:dind_380],inditem[:koef],inditem[:enrg_380],nil]
              @report << [nil,nil,'r/liv',nil,nil,inditem[:ind1_480],inditem[:ind0_480],inditem[:dind_480],inditem[:koef],inditem[:enrg_480],nil]
            end
          end
        end     
        unless energies[:wa].nil? then 
          @report << [nil,'Energie a/pr',nil,nil,nil,nil,nil,nil,nil,energies[:wa],nil]
          cp_enrgsums[0] += energies[:wa]  
        end
        unless energies[:waliv].nil? then 
          @report << [nil,'Energie a/liv',nil,nil,nil,nil,nil,nil,nil,energies[:waliv],nil]
          cp_enrgsums[1] += energies[:waliv]
        end 
        unless energies[:wri].nil? then 
          @report << [nil,'Energie r/pr',nil,nil,nil,nil,nil,nil,nil,energies[:wri],nil]
          cp_enrgsums[2] += energies[:wri] 
        end 
        unless energies[:wrc].nil? then 
          @report << [nil,'Energie r/liv',nil,nil,nil,nil,nil,nil,nil,energies[:wrc],nil]
          cp_enrgsums[3] += energies[:wrc]  
        end
        # pierderi   
        losses = one_mp_losses(item.id, energies)
        unless losses[:cosfi].nil? then @report << [nil,'cos φ',nil,nil,nil,nil,nil,nil,nil,losses[:cosfi],nil] end
        unless losses[:tau].nil? then @report << [nil,'ζ',nil,nil,nil,nil,nil,nil,nil,losses[:tau],nil] end  
        unless losses[:tr_losses_pxx].nil? then @report << [nil,'Потери тр-ра Pxx',nil,nil,nil,nil,nil,nil,nil,losses[:tr_losses_pxx],nil] end
        unless losses[:tr_losses_pkz].nil? then @report << [nil,'Потери тр-ра Pкз',nil,nil,nil,nil,nil,nil,nil,losses[:tr_losses_pkz],nil] end
        unless losses[:tr_losses_p].nil? then 
          @report << [nil,'Потери тр-ра P суммарные',nil,nil,nil,nil,nil,nil,nil,losses[:tr_losses_p],2]
          trlosses += losses[:tr_losses_p] 
        end  
        unless losses[:tr_losses_rxx].nil? then @report << [nil,'Потери тр-ра Rxx',nil,nil,nil,nil,nil,nil,nil,losses[:tr_losses_rxx],nil] end
        unless losses[:tr_losses_rkz].nil? then @report << [nil,'Потери тр-ра Rкз',nil,nil,nil,nil,nil,nil,nil,losses[:tr_losses_rkz],nil] end
        unless losses[:tr_losses_r].nil? then @report << [nil,'Потери тр-ра R суммарные',nil,nil,nil,nil,nil,nil,nil,losses[:tr_losses_r],2] end
        unless losses[:ln_losses_ng].nil? then @report << [nil,'Потери ВЛ нагрузочные',nil,nil,nil,nil,nil,nil,nil,losses[:ln_losses_ng],nil] end 
        unless losses[:ln_losses_kr].nil? then @report << [nil,'Потери ВЛ на корону',nil,nil,nil,nil,nil,nil,nil,losses[:ln_losses_kr],nil] end
        unless losses[:ln_losses].nil? then 
          @report << [nil,'Потери ВЛ суммарные',nil,nil,nil,nil,nil,nil,nil,losses[:ln_losses],2]
          lnlosses += losses[:ln_losses] 
        end
        unless losses[:cosf].nil? then @report << [nil,'cos φ с потерями',nil,nil,nil,nil,nil,nil,nil,losses[:cosf],nil] end       
        unless losses[:consumteh].nil? then 
          @report << [nil,'Технологический расход',nil,nil,nil,nil,nil,nil,nil,losses[:consumteh],2]
          consumteh += losses[:consumteh] 
        end    
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

  def one_mp_indicii(mp_id, ddate_b, ddate_e)
    result={}
    mpoint = Mpoint.find(mp_id)
    wa = waliv = wri = wrc = 0.0
    indicii = []       
    mvnum = 0
    dtsum = 0  
    meters = Vmpointsmeter.where("id = ? AND ((? between relevance_date AND relevance_end) OR (? between relevance_date AND relevance_end))", mp_id, ddate_b, ddate_e).order(:meter_id)
    if meters.count == 0 then
       flash[:warning] = "У точки учета #{mpoint.name} нет счетчиков!"          
    else  
       meters.each do |mitem|         
         koef = mitem.koefcalc           #koef 
         indicii0 = {:meternum => mitem.meternum, :koef => koef}
         mvalues = Vmpointsmetersvalue.where("id = ? AND meter_id = ? AND (actdate between ? AND  ?)", mpoint.id, mitem.meter_id,ddate_b, ddate_e).order(:actdate, :mvalue_updated_at)
         if mvalues.count != 0 then
              if mvalues.count != 1 then  mvnum = 2 end
              mvalue0 = mvalues.first
              mvalue1 = mvalues.last               
              date1 = mvalue1.actdate         #date1           
              date0 = mvalue0.actdate         #date0
              dt = (date1 - date0).to_i       #dt
              dtsum += dt                     #dtsum
              indicii0 = {:meternum => mitem.meternum, :koef => koef, :date0 => date0, :date1 => date1, :dt => dt} 
              ind1 = indicii0[:ind1_180] = mvalue1.actp180          #180
              ind0 = indicii0[:ind0_180] = mvalue0.actp180          #180 
              dind = indicii0[:dind_180] = (ind1 - ind0).round(4)   #dind   180      
              energy = indicii0[:enrg_180] = (dind * koef).round(4) #energy 180
              wa += energy
              ind1 = indicii0[:ind1_280] = mvalue1.actp280          #280
              ind0 = indicii0[:ind0_280] = mvalue0.actp280          #280
              dind = indicii0[:dind_280] = (ind1 - ind0).round(4)   #dind 280         
              energy = indicii0[:enrg_280] = (dind * koef).round(4) #energy 280
              waliv += energy
              ind1 = indicii0[:ind1_380] = mvalue1.actp380          #380 
              ind0 = indicii0[:ind0_380] = mvalue0.actp380          #380
              dind = indicii0[:dind_380] = (ind1 - ind0).round(4)   #dind 380         
              energy = indicii0[:enrg_380] = (dind * koef).round(4) #energy 380
              wri += energy
              ind1 = indicii0[:ind1_480] = mvalue1.actp480          #480
              ind0 = indicii0[:ind0_480] = mvalue0.actp480          #480
              dind = indicii0[:dind_480] = (ind1 - ind0).round(4)   #dind 480         
              energy = indicii0[:enrg_480] = (dind * koef).round(4) #energy 480
              wrc += energy          
         end # if mvalues.count
         indicii  << indicii0     
       end  # meters.each
       result[:dt] = dtsum
       result[:indicii] = indicii
       result[:mvnum] = mvnum
       if mvnum == 2 then
         # energies
         result[:wa] = wa
         result[:waliv] = waliv
         result[:wri] = wri
         result[:wrc] = wrc         
       end # if mvnum
     end # if meters.count 
     result
  end

  def one_mp_losses(mp_id, indicii)
    result={}
    mpoint = Mpoint.find(mp_id)
    mvnum = indicii[:mvnum]       
    if mvnum == 2 then
      wa    = indicii[:wa] 
      waliv = indicii[:waliv]
      wri   = indicii[:wri]
      wrc   = indicii[:wrc] 
      dtsum = indicii[:dt]       
      # косинус фи 
      if wa != 0 || wri != 0 then 
        cosfi = ((wa ** 2 / (wa ** 2 + wri ** 2)) ** 0.5).round(4)  #cos fi 
        result[:cosfi] = cosfi       
      end 
      # трансформаторы
      tr  = mpoint.trparams.where("f = 'true'")
      tr_losses_pxx = tr_losses_pkz = tr_losses_rxx = tr_losses_rkz = 0.0
      if tr.count != 0 then
        tr.each do |tritem|
          tr_losses_pxx += dtsum * 24 * tritem.pxx
          #tau
          taus  = Tau.all
          tau = taus.last.taum
          tm = taus.last.tm 
          taus.each do |itau|
            if wa <= 0.9 * itau.tm * cosfi * (tritem.snom) then 
              tau = itau.taum
              tm = itau.tm
              break                       
            end
          end
          result[:tau] = tau
          result[:tm] = tm
          if tritem.snom == 0 then
            flash[:warning] = "Невозможно рассчитать потери КЗ тр-ра для #{mpoint.name}, т.к. Snom = 0 !"                   
          else  
            tr_losses_pkz += tritem.pkz * tau * (wa ** 2 + wri ** 2) / ((tm ** 2) * ((tritem.snom) ** 2))
            tr_losses_rkz += tritem.qkz * tau * (wa ** 2 + wri ** 2) / ((tm ** 2) * ((tritem.snom) ** 2))
          end
          tr_losses_rxx += (((tritem.io ** 2) * (tritem.snom ** 2) / 10000 - tritem.pxx ** 2) ** 0.5) * dtsum * 24
        end  # tr.each
        tr_losses_pxx = result[:tr_losses_pxx] = tr_losses_pxx.round(4)
        tr_losses_pkz = result[:tr_losses_pkz] = tr_losses_pkz.round(4)
        tr_losses_rxx = result[:tr_losses_rxx] = tr_losses_rxx.round(4)
        tr_losses_rkz = result[:tr_losses_rkz] = tr_losses_rkz.round(4)
        result[:tr_losses_p] = tr_losses_pxx + tr_losses_pkz 
        result[:tr_losses_r] = tr_losses_rxx + tr_losses_rkz              
      end  # if tr.count
      # линии              
      ln  = mpoint.lnparams.where("f = 'true'") 
      ln_losses_ng = ln_losses_kr = 0.0        
      if ln.count == 0 then
        flash[:warning] = "У точки учета #{mpoint.name} нет линий!"  
      elsif dtsum != 0 then
        if mpoint.voltcl == 0 then
          flash[:warning] = "Невозможно рассчитать потери в линии для #{mpoint.name}, т.к. voltcl = 0 !" 
        else               
          rk = 0.0
          ln.each do |lnitem|
            rk += lnitem.r * (lnitem.k_f ** 2)
          end
          ln_losses_ng = result[:ln_losses_ng] = ( rk * (wa ** 2 + wri ** 2) / (1000 * ((mpoint.voltcl) ** 2) * dtsum * 24) ).round(4)
          ln_losses_kr = result[:ln_losses_kr] = ln_losses_kr.round(4)
          result[:ln_losses] = ln_losses_ng + ln_losses_kr              
        end
      end  # if ln.count
      # cos fi with losses
      ct = 0.0             
      if wa >= 10000 then
           wal = wa + tr_losses_pkz + tr_losses_pxx + ln_losses_ng + ln_losses_kr
           wrl = wri + tr_losses_rkz + tr_losses_rxx
           cosf = result[:cosf] = (wal / ((wal ** 2 + wrl ** 2) ** 0.5)).round(4)
           wrio = wal * 0.567
           if wrio < wri then
             wrif = wri - wrio
           else
             wrif = 0.0
           end
           ct = result[:consumteh] = ((wrc + wrif ) * 0.1).round(4)
       end #if wa               
     end # if mvnum
   result
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
