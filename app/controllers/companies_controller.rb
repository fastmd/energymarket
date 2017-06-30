class CompaniesController < ApplicationController
before_filter :check_user
before_filter :redirect_cancel, only: [:create, :update] 
  
  def new
  end
  
  def all
    if params[:cp_id].nil? then
      @company = Company.new
    else
      @company = Company.find(params[:cp_id])
      params[:cp_id] = nil
    end 
    indexviewall  
  end
  
  def create
    @company = Company.new
    @company = company_init(@company)  
    begin
      @company.save! 
      flash.discard
      flash[:notice] = "Потребитель #{@company.name} сохранен." 
      redirect_to companies_all_path(:page=>params[:page])           
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'add' 
      indexviewall
      render "all"          
    end      
  end
  
  def update
    begin    
      @company = Company.find(params[:cp_id])
      @company = company_init(@company)
      @company.save! 
      flash.discard
      flash[:notice] = "Потребитель #{@company.name} сохранен." 
      redirect_to companies_all_path(:page=>params[:page])               
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'edit'
      indexviewall
      render "all"       
    end  
  end  

  def edit
    @flag = 'edit'
    @company = Company.find(params[:cp_id])
    flash.discard
    indexviewall
    render "all"  
  end

  def index
    if params[:cp_id].nil? then
      @company = Company.new
    else
      @company = Company.find(params[:cp_id])
      params[:cp_id] = nil
    end  
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end   
    @mpoint = Mpoint.new 
    @sstations = Mesubstation.where("f = ?", true).order(name: :asc).pluck(:name, :id)
    @comps = Company.where("f = ?", true).order(name: :asc).pluck(:name, :id)
    @furns = if (@flr.nil? || (@fpr < 6)) then Furnizor.all.pluck(:name, :id)  else [[@flr.name, @flr.id]] end
    @fils  = if (@flr.nil? || (@fpr >= 6)) then Filial.all.pluck(:name, :id)   else [[@flr.name, @flr.id]] end   
    @fcomps = Vallmpoint.select(:company_shname).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(company_shname: :asc).pluck(:company_shname)
    @fsstations = Vallmpoint.select(:mesubstation_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(mesubstation_name: :asc).pluck(:mesubstation_name)
    @ffurns = if (@flr.nil? || (@fpr < 6))  then Vallmpoint.select(:furnizor_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(furnizor_name: :asc).pluck(:furnizor_name) else [[@flr.name]] end
    @ffils  = if (@flr.nil? || (@fpr >= 6)) then Vallmpoint.select(:filial_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(filial_name: :asc).pluck(:filial_name)   else [[@flr.name]] end 
    @fregions = Vallmpoint.select(:region_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(region_name: :asc).pluck(:region_name)     
    indexview            
  end
  
  def show     
    @cp =  Company.find(params[:id])
    if @fpr < 6  then  @flr = Filial.find(params[:flr_id]) else @flr =  Furnizor.find(params[:flr_id]) end 
    @mpoint = @cp.mpoints.build
    @mp =  Vallmpoint.where(if @fpr < 6 then "filial_id = ? and company_id = ?" else "furnizor_id = ? and company_id = ?" end, @flr.id, @cp.id).order(name: :asc, created_at: :asc) 
    @mp =  @mp.paginate(:page => params[:page], :per_page => @perpage = $PerPage )
    @sstations = Mesubstation.where("f = ?", true).order(name: :asc).pluck(:name, :id)
    @furns = if (@flr.nil? || (@fpr < 6)) then Furnizor.all.pluck(:name, :id)  else [[@flr.name, @flr.id]] end
    @fils  = if (@flr.nil? || (@fpr >= 6)) then Filial.all.pluck(:name, :id)   else [[@flr.name, @flr.id]] end  
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
    redirect_to companies_all_path(:page=>params[:page]) 
  end    

  def mvreport
    @page = params[:page]
    @id = params[:cp_id]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr = Filial.find(params[:flr_id]) else @flr = Furnizor.find(params[:flr_id]) end
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
    if @fpr < 6 then  @flr = Filial.find(params[:flr_id]) else @flr = Furnizor.find(params[:flr_id]) end
    @meters = Vmpointsmeter.where("company_id = ?", @id).order(:name, :id, :relevance_date, :updated_at)
  end  
 
  def paramreport
    @page = params[:page]
    @id = params[:cp_id]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr = Filial.find(params[:flr_id]) else @flr = Furnizor.find(params[:flr_id]) end 
    @trp = Vmpointstrparam.where("company_id = ?", @id).order(:name, :id, :tr_id, :updated_at)
    @lnp = Vmpointslnparam.where("company_id = ?", @id).order(:name, :id, :ln_id, :updated_at)
    @tau = Tau.all    
  end  
  
  def onempreport
    @page = params[:page]
    @id = params[:id]
    @month_for_report = params[:month_for_report]
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end    
    # month   
    if @month_for_report.nil? then @ddate = Date.current - 1.month else @ddate = Date.strptime(@month_for_report, '%Y-%m') end
   #if @month_for_report.nil? then @ddate = Date.current else @ddate = Date.strptime(@month_for_report, '%Y-%m') end   #changed for month to be liked by setsu
    @luna = $Luni[@ddate.month.to_i-1]
    @ddate_b = @ddate.change(day: 1)
   #@ddate_b = @ddate.change(day: 1) - 1.month #changed for month to be liked by setsu
    @ddate_mb = @ddate_b + 1.month - 1.day    
    @ddate_e = @ddate.change(day: 1) + 2.month - 1.day
   #@ddate_e = @ddate.change(day: 1) + 1.month - 1.day #changed for month to be liked by setsu
    @ddate_me = @ddate_e.change(day: 1)   
    @luna_b = $Luni[@ddate_b.month.to_i-1] + ' ' + @ddate_b.year.to_s
    @luna_e = $Luni[@ddate_e.month.to_i-1] + ' ' + @ddate_e.year.to_s
    @mp = Mpoint.find(params[:mp_id])
    @cp = @mp.company  
    # title
    @lista_title = []
    @lista_title << "Расчет потребления и потерь для потребителя #{@cp.name}"
    @lista_title << "точка учета #{@mp.cod} #{@mp.mesubstation.name} #{@mp.voltcl} Î #{@mp.meconname} F" 
    @lista_title << "за месяц #{@luna} #{@ddate.year} года" 
    # report init
    @report = Array[] 
    # indicii si energie        
    @energies = one_mp_indicii(@mp.id, @ddate_b, @ddate_e, @ddate_mb, @ddate_me)
    @indicii = @energies[:indicii]
    # pierderi   
    @losses = one_mp_losses(@mp.id, @energies)
    @ttaus = @losses[:ttaus]
    # params
    @trp = Vmpointstrparam.where("id = ?", @mp.id).order(:name, :id, :tr_id, :updated_at)
    @lnp = Vmpointslnparam.where("id = ?", @mp.id).order(:name, :id, :ln_id, :updated_at)
    @tau = Tau.all   
  end
   
  def reports
    @page = params[:page]
    @id = params[:id]
    @month_for_report = params[:month_for_report]
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end    
    # month   
    if @month_for_report.nil? then @ddate = Date.current - 1.month else @ddate = Date.strptime(@month_for_report, '%Y-%m') end
    @luna = $Luni[@ddate.month.to_i-1]
    @ddate_b = @ddate.change(day: 1)
    @ddate_mb = @ddate_b + 1.month - 1.day 
    @ddate_e = @ddate.change(day: 1) + 2.month - 1.day
    @ddate_me = @ddate_e.change(day: 1)   
    @luna_b = $Luni[@ddate_b.month.to_i-1] + ' ' + @ddate_b.year.to_s
    @luna_e = $Luni[@ddate_e.month.to_i-1] + ' ' + @ddate_e.year.to_s
    # title
    @lista_title = []
    @lista_title << "LISTA de calcul a intrarii energiei electrice pentru"
    @lista_title << ("consumatori  alimentați direct de la stații  electrice Î.S. ”Moldelectrica”" + (if @fpr < 6 then " filiala RETÎ" else " furnizorul" end) + " #{@flr.name}") 
    @lista_title << "pentru luna #{@luna} anul #{@ddate.year}"
    @title1 = ['№','№ locului de consum','Nume client','RRE,SE si liniilor','Conexiunea','№ contor.',
              'Data citirii','Indicatii cur. activ','Indicatii cur. reactiv L','Indicatii cur. reactiv C',
              'Data citirii','Indicatii pr. activ','Indicatii pr. reactiv L','Indicatii pr. reactiv C',
              'Coeficient contor','ENERGIA, kWh activ','ENERGIA, kWh reactiv L','ENERGIA, kWh reactiv C',
              'Pierderi LEA, kWh','Pierderi trans, kWh','Consum Tehnologic, kWh inductiv','Consum Tehnologic, kWh capacitiv']
    i = 1
    @title2 = []
    @title1.each do |t|
      @title2 << i
      i += 1
    end
    # report init
    @report = Array[]
    # filter
    @data_for_search = @@data_for_search
    @qmesubstation = @@qmesubstation
    @qcompany = @@qcompany
    @qregion = @@qregion
    @qfilial = @@qfilial
    @qfurnizor = @@qfurnizor    
    # companies
    company_list = @flr.vallmpoints.pluck(:company_id).uniq
    if @data_for_search.empty? then
      if @qmesubstation.empty? and @qcompany.empty? and @qregion.empty? and @qfilial.empty? and @qfurnizor.empty? then   
       company_list = @flr.vallmpoints.where(if @fpr < 6 then "filial_id = ?" else "furnizor_id = ?" end, @flr.id).pluck(:company_id).uniq
       @filter = 0
      else
       @filter = 1         
       company_list = @flr.vallmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                               "and (?='' or mesubstation_name=?) and (?='' or region_name=?) and (?='' or company_shname=?) and (?='' or filial_name=?)" +
                               " and (?='' or furnizor_name=?)", 
                               @flr.id, @qmesubstation, @qmesubstation, @qregion, @qregion, @qcompany, @qcompany, @qfilial, @qfilial, @qfurnizor, @qfurnizor).pluck(:company_id).uniq
      end  
    else
       @filter = 1
       @data_for_search = @data_for_search.upcase
       data_for_search = "%" + @data_for_search + "%"
       company_list = @flr.vallmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                               "and (upper(company_name||company_shname) like upper(?) "+ 
                               "or upper(cod||name) like upper(?) "+ 
                               "or upper(filial_name||region_name||furnizor_name) like upper(?) "+ 
                               "or upper(mesubstation_name) like upper(?)) ", 
                               @flr.id, data_for_search, data_for_search, data_for_search, data_for_search).pluck(:company_id).uniq
    end    
    companies = (Company.where(f: 'true').order(shname: :asc).find(company_list))
    if companies.count != 0 then 
      nr = 0
      companies.each do |cp|
        # mpoints 
        mpoints = cp.mpoints.where(f: 'true').order(:name, :id)
        if mpoints.count == 0 then
          flash[:warning] = "Нет данных для отчета. Потребитель #{cp.name} не имеет точек учета." 
        else
          mpoints.each do |mp|
           if (@flr.class.name.demodulize == 'Filial' && mp.mesubstation.filial_id == @flr.id) || (@flr.class.name.demodulize == 'Furnizor' && mp.furnizor_id == @flr.id)  then
            # report rind
            nr += 1
            report_rind = [nr,"#{mp.cod}","#{cp.name}","#{mp.mesubstation.name}",if mp.meconname.count("a-zA-Zа-яА-Я") > 0 then mp.meconname else"#{mp.voltcl} Î #{mp.meconname} F" end,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
            # indicii si energie        
            energies = one_mp_indicii(mp.id, @ddate_b, @ddate_e, @ddate_mb, @ddate_me)
            indicii = energies[:indicii]
            if indicii.nil? then
              report_rind[@title1.count] = 1
            else   
              indicii0 = indicii.first
              indicii1 = indicii.last
              # pierderi   
              losses = one_mp_losses(mp.id, energies)
              # report
              report_rind[5]  = indicii0[:meternum]
              unless indicii0[:date0].nil? then report_rind[6]  = (indicii0[:date0]).to_formatted_s(:day_month_year) end
              unless indicii0[:ind0_180].nil? then report_rind[7]  = indicii0[:ind0_180].round end
              unless indicii0[:ind0_380].nil? then report_rind[8]  = indicii0[:ind0_380].round end
              unless indicii0[:ind0_480].nil? then report_rind[9]  = indicii0[:ind0_480].round end
              unless indicii1[:date1].nil? then report_rind[10]  = (indicii1[:date1]).to_formatted_s(:day_month_year) end
              unless indicii1[:ind1_180].nil? then report_rind[11]  = indicii1[:ind1_180].round end
              unless indicii1[:ind1_380].nil? then report_rind[12]  = indicii1[:ind1_380].round end
              unless indicii1[:ind1_480].nil? then report_rind[13]  = indicii1[:ind1_480].round end
              unless indicii1[:koef].nil? then report_rind[14]  = indicii1[:koef].round end
              unless energies[:wa_without_wasub].nil? then report_rind[15]  = energies[:wa_without_wasub].round end
              unless energies[:wri].nil? then report_rind[16]  = energies[:wri].round end
              unless energies[:wrc].nil? then report_rind[17]  = energies[:wrc].round end
              unless losses.nil? then
                unless losses[:ln_losses].nil? then report_rind[18]  = losses[:ln_losses].round end
                unless losses[:tr_losses_p].nil? then report_rind[19]  = losses[:tr_losses_p].round end                
                unless losses[:consumtehi].nil? then report_rind[20]  = losses[:consumtehi].round end
                unless losses[:consumtehc].nil? then report_rind[21]  = losses[:consumtehc].round end
              end              
            end # indicii null
            @report << report_rind[0..@title1.count]  
          end  # mpoints each        
        end  # mpoints.count 
       end 
      end  #compaies each    
    end  #companies.count
    respond_to do |format|
      format.html
      format.pdf { send_data ListaReports.new.to_pdf(@flr,@report,@luna,@ddate,@luna_b,@luna_e), :type => 'application/pdf', :filename => "lista.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="lista.xlsx"' }
    end  
  end
 
  def report
    @page = params[:page]
    @id = params[:cp_id]
    @month_for_report = params[:month_for_report]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr =  Filial.find(params[:flr_id]) else @flr =  Furnizor.find(params[:flr_id]) end
    # month   
    if @month_for_report.nil? then @ddate = Date.current - 1.month else @ddate = Date.strptime(@month_for_report, '%Y-%m') end
    @luna = $Luni[@ddate.month.to_i-1]
    @ddate_b = @ddate.change(day: 1)
    @ddate_mb = @ddate_b + 1.month - 1.day 
    @ddate_e = @ddate.change(day: 1) + 2.month - 1.day
    @ddate_me = @ddate_e.change(day: 1)   
    @luna_b = $Luni[@ddate_b.month.to_i-1] + ' ' + @ddate_b.year.to_s
    @luna_e = $Luni[@ddate_e.month.to_i-1] + ' ' + @ddate_e.year.to_s
    # report init
    @report = Array[]
    nr = 0
    cp_enrgsums = [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    trlosses = 0.0 
    lnlosses = 0.0
    consumteh = 0.0 
    # mpoints 
    @mpoints = @cp.mpoints.where(f: 'true').order(:name,:id)
    if @mpoints.count == 0 then
      flash[:warning] = "Нет данных для отчета. Потребитель #{@cp.name} не имеет точек учета." 
    else
      @mpoints.each do |mp| 
        nr += 1  
        report_rind = [nr, "#{mp.cod} #{mp.name} #{mp.mesubstation.name}", if mp.meconname.count("a-zA-Zа-яА-Я") > 0 then mp.meconname else"#{mp.voltcl} Î #{mp.meconname} F" end, "#{mp.clconname}", nil, nil, nil, nil, nil, nil, nil, nil] 
        # indicii si energie        
        energies = one_mp_indicii(mp.id, @ddate_b, @ddate_e, @ddate_mb, @ddate_me)
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
        unless energies[:wasub].nil? then 
          @report << [nil,'Energie a/pr subabonent',nil,nil,nil,nil,nil,nil,nil,energies[:wasub],nil]
          cp_enrgsums[4] += energies[:wasub]  
        end
        unless energies[:wa_without_wasub].nil? then 
          @report << [nil,'Energie a/pr fara subabonent',nil,nil,nil,nil,nil,nil,nil,energies[:wa_without_wasub],nil]
          cp_enrgsums[5] += energies[:wa_without_wasub]  
        end
        # Trab
        unless energies[:workt].nil? then @report << [nil,'Tраб, часы',nil,nil,nil,nil,nil,nil,nil,energies[:workt],2] end
        # pierderi   
        losses = one_mp_losses(mp.id, energies)
        unless losses[:cosfi].nil? then @report << [nil,'cos φ расчетный',nil,nil,nil,nil,nil,nil,nil,losses[:cosfi],nil] end
        unless losses[:cosfi_contract].nil? then @report << [nil,'cos φ контрактный',nil,nil,nil,nil,nil,nil,nil,losses[:cosfi_contract],2] end
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
    @report << ['∑','Итого Energie a/pr subabonent',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[4],4]
    @report << ['∑','Итого Energie a/pr fara subabonent',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[5],4]       
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

  def one_mp_indicii(mp_id, ddate_b, ddate_e, ddate_mb, ddate_me)
    result={}
    mpoint = Mpoint.find(mp_id)
    wa = waliv = wri = wrc = wasub = 0.0
    indicii = []       
    mvnum = 0 
    meters = Vmpointsmeter.where("id = ? AND ((? between relevance_date AND relevance_end) OR (? between relevance_date AND relevance_end))", mp_id, ddate_b, ddate_e).order(:meter_id)
    if meters.count == 0 then
       flash[:warning] = "У точки учета #{mpoint.name} нет счетчиков!"          
    else 
       # billing days
       dddate_b = ddate_b
       dddate_e = ddate_e
       mvalues = Vmpointsmetersvalue.where("id = ? AND (actdate between ? AND  ?) AND r = 'true'", mpoint.id, ddate_b, ddate_mb).order(:actdate, :mvalue_updated_at).first
       unless mvalues.nil? then dddate_b = mvalues.actdate end
       mvalues = Vmpointsmetersvalue.where("id = ? AND (actdate between ? AND  ?) AND r = 'true'", mpoint.id, ddate_me, ddate_e).order(:actdate, :mvalue_updated_at).last
       unless mvalues.nil? then dddate_e = mvalues.actdate end       
       # indicii      
       dtsum  = 0
       trabsum = nil
       result[:wa_formula] = ""
       result[:waliv_formula] = ""
       result[:wri_formula] = ""
       result[:wrc_formula] = ""
       meters.each do |mitem|         
         koef = mitem.koefcalc           #koef 
         indicii0 = {:meternum => mitem.meternum, :koef => koef}
         mvalues = Vmpointsmetersvalue.where("id = ? AND meter_id = ? AND (actdate between ? AND  ?)", mpoint.id, mitem.meter_id, dddate_b, dddate_e).order(:actdate, :mvalue_updated_at)
         if mvalues.count != 0 then
              if mvalues.count != 1 then  mvnum = 2 end  
              mvalue0 = mvalues.first
              mvalue1 = mvalues.last               
              date1 = mvalue1.actdate         #date1           
              date0 = mvalue0.actdate         #date0
              dt = (date1 - date0).to_i       #dt
              trab = mvalue1.trab             #trab from act
              dwa  = mvalue1.dwa              #dwa  from act
              indicii0 = {:meternum => mitem.meternum, :koef => koef, :date0 => date0, :date1 => date1, :dt => dt} 
              if trab.nil? or trab == 0 then 
                dtsum += dt                     #dtsum
              else
                if trabsum.nil? then trabsum = 0 end 
                trabsum += trab
                indicii0[:trab] = trab
              end     
              indicii0[:ind1_180] = mvalue1.actp180          #180
              ind1 = if mvalue1.actp180.nil? then 0 else mvalue1.actp180 end
              indicii0[:ind0_180] = mvalue0.actp180          #180 
              ind0 = if mvalue0.actp180.nil? then 0 else mvalue0.actp180 end
              dind = indicii0[:dind_180] = (ind1 - ind0).round(4)   #dind   180      
              energy = indicii0[:enrg_180] = (dind * koef).round(4) #energy 180
              unless mpoint.fturn then
                if result[:wa_formula] != "" then result[:wa_formula] += " + "  end  
                result[:wa_formula] += dind.to_s + " * " + koef.to_s
                wa += energy
              else
                if result[:waliv_formula] != "" then result[:waliv_formula] += " + "  end
                result[:waliv_formula] += dind.to_s + " * " + koef.to_s                
                if mvalue1.fanulare then 
                  waliv += energy
                  indicii0[:fanulare] = mvalue1.fanulare
                end
              end  
              unless dwa.nil? then 
                wasub +=dwa
                indicii0[:dwa] = dwa 
              end
              indicii0[:ind1_280] = mvalue1.actp280          #280
              ind1 = if mvalue1.actp280.nil? then 0 else mvalue1.actp280 end
              indicii0[:ind0_280] = mvalue0.actp280          #280
              ind0 = if mvalue0.actp280.nil? then 0 else mvalue0.actp280 end
              dind = indicii0[:dind_280] = (ind1 - ind0).round(4)   #dind 280         
              energy = indicii0[:enrg_280] = (dind * koef).round(4) #energy 280
              unless mpoint.fturn then 
                if result[:waliv_formula] != "" then result[:waliv_formula] += " + "  end
                result[:waliv_formula] += dind.to_s + " * " + koef.to_s                
                if mvalue1.fanulare then 
                  waliv += energy
                  indicii0[:fanulare] = mvalue1.fanulare
                end
              else
                if result[:wa_formula] != "" then result[:wa_formula] += " + "  end
                result[:wa_formula] += dind.to_s + " * " + koef.to_s
                wa += energy                
              end  
              indicii0[:ind1_380] = mvalue1.actp380          #380 
              ind1 = if mvalue1.actp380.nil? then 0 else mvalue1.actp380 end
              indicii0[:ind0_380] = mvalue0.actp380          #380
              ind0 = if mvalue0.actp380.nil? then 0 else mvalue0.actp380 end
              dind = indicii0[:dind_380] = (ind1 - ind0).round(4)   #dind 380         
              energy = indicii0[:enrg_380] = (dind * koef).round(4) #energy 380
              unless mpoint.fturn then
                if result[:wri_formula] != "" then result[:wri_formula] += " + "  end   
                result[:wri_formula] += dind.to_s + " * " + koef.to_s
                wri += energy
              else
                if result[:wrc_formula] != "" then result[:wrc_formula] += " + "  end                 
                result[:wrc_formula] += dind.to_s + " * " + koef.to_s              
                wrc += energy                
              end  
              indicii0[:ind1_480] = mvalue1.actp480          #480
              ind1 = if mvalue1.actp480.nil? then 0 else mvalue1.actp480 end
              indicii0[:ind0_480] = mvalue0.actp480          #480
              ind0 = if mvalue0.actp480.nil? then 0 else mvalue0.actp480 end
              dind = indicii0[:dind_480] = (ind1 - ind0).round(4)   #dind 480         
              energy = indicii0[:enrg_480] = (dind * koef).round(4) #energy 480              
              unless mpoint.fturn then
                if result[:wrc_formula] != "" then result[:wrc_formula] += " + "  end                 
                result[:wrc_formula] += dind.to_s + " * " + koef.to_s              
                wrc += energy
              else
                if result[:wri_formula] != "" then result[:wri_formula] += " + "  end   
                result[:wri_formula] += dind.to_s + " * " + koef.to_s
                wri += energy                
              end            
         end # if mvalues.count
         indicii  << indicii0     
       end  # meters.each
       result[:indicii] = indicii
       result[:mvnum] = mvnum
       if mvnum == 2 then
         # work hours
         if trabsum.nil? then
          result[:workt] = dtsum * 24
          result[:workt_formula] = dtsum.to_s + " * 24  = "
         else
          result[:trab] = trabsum 
          result[:workt] = dtsum * 24 + trabsum
          result[:workt_formula] = dtsum.to_s + " * 24 + " + trabsum.to_s + " = "
         end           
         # energies
         result[:wa] = wa
         result[:wasub] = wasub
         result[:wa_without_wasub] = if wa > wasub then (wa - wasub) else 0.0 end
         result[:wa_without_wasub_formula] = wa.to_s + " - " + wasub.to_s + " = " 
         result[:wa_formula] += " = "
         result[:waliv] = waliv
         result[:waliv_formula] += " = "
         result[:wri] = wri
         result[:wri_formula] += " = "
         result[:wrc] = wrc
         result[:wrc_formula] += " = "
         result[:wr] = wri + wrc
         result[:wr_formula] = " #{wri} + #{wrc} = "
         # косинус фи контрактный
         result[:cosfi_contract] = cosfi_contract = mpoint.cosfi
         if !cosfi_contract.nil? and cosfi_contract != 0 then
           result[:tgfi_contract] = tgfi_contract = ((1 / (cosfi_contract ** 2) - 1 ) ** 0.5).round(8) # tg fi
           result[:tgfi_contract_formula] = "(1 / (#{cosfi_contract} ^2) - 1 ) ^0.5 = " # tg fi
           result[:wr] = (wa - wasub) * tgfi_contract
           result[:wr_formula] = " #{wa - wasub} * #{tgfi_contract} = "           
         end 
       end # if mvnum
     end # if meters.count 
     result
  end

  def one_mp_losses(mp_id, indicii)
    result={}   
    mpoint = Mpoint.find(mp_id)
    mvnum = indicii[:mvnum]       
    if mvnum == 2 && (indicii[:wa_without_wasub]!=0 || indicii[:waliv]!=0 || indicii[:wri]!=0 || indicii[:wrc]!=0) then
      wa    = indicii[:wa_without_wasub] 
      waliv = indicii[:waliv] 
      wri   = indicii[:wri]
      wrc   = indicii[:wrc]  
      wr    = indicii[:wr]
      workt = indicii[:workt]       
      # косинус фи 
      if wa != 0 || wri != 0 then 
        cosfi = ((wa ** 2 / (wa ** 2 + wri ** 2)) ** 0.5).round(4)  #cos fi 
        result[:cosfi] = cosfi
        result[:cosfi_formula] = "(" + wa.to_s + "^2 / (" + wa.to_s + " ^2 + " + wri.to_s + " ^2 )) ^0.5 = "       
      end
      # косинус фи контрактный
      result[:cosfi_contract] = indicii[:cosfi_contract]
      result[:tgfi_contract] = indicii[:tgfi_contract] # tg fi
      result[:tgfi_contract_formula] = indicii[:tgfi_contract_formula] # tg fi 
      #tau
      taus  = Tau.all
      ttaus = []  
      # трансформаторы
      tr  = mpoint.trparams.where("f = 'true'")
      tr_losses_p = tr_losses_pxx = tr_losses_pkz = tr_losses_r = tr_losses_rxx = tr_losses_rkz = 0.0
      result[:tr_losses_pxx_formula] = ""
      result[:tr_losses_rxx_formula] = ""
      result[:tr_losses_pkz_formula] = ""
      result[:tr_losses_rkz_formula] = ""
      if tr.count != 0 then
        tr.each do |tritem|                  
          unless mpoint.four then
            tr_losses_pxx += workt * tritem.transformator.pxx
            if result[:tr_losses_pxx_formula] != "" then result[:tr_losses_pxx_formula] += " + "  end
            result[:tr_losses_pxx_formula] += workt.to_s + " * " + (tritem.transformator.pxx).to_s
          else
            if result[:tr_losses_pxx_formula] != "" then result[:tr_losses_pxx_formula] += " + "  end
            result[:tr_losses_pxx_formula] += "наш трансформатор"             
          end  
          #tau
          tau = taus.last.taum
          tm = taus.last.tm
          taus.each do |itau|
            if wa <= 0.9 * itau.tm * cosfi * (tritem.transformator.snom) then 
              tau = itau.taum
              tm = itau.tm
              break                       
            end
          end
          result[:tau] = tau
          result[:tm] = tm 
          ttaus << {:tm => tm, :tau => tau, :cosfi => cosfi, :snom => tritem.transformator.snom, 
                    :wi => tau * cosfi * (tritem.transformator.snom), :wi_formula => tau.to_s + " * " + cosfi.to_s + " * " + (tritem.transformator.snom).to_s + " = ",
                    :wi09 => 0.9 * tau * cosfi * (tritem.transformator.snom), :wi09_formula => " 0.9 * " + tau.to_s + " * " + cosfi.to_s + " * " + (tritem.transformator.snom).to_s + " = ",
                    :wa => wa}
          if tritem.transformator.snom == 0 then
            flash[:warning] = "Невозможно рассчитать потери КЗ тр-ра для #{mpoint.name}, т.к. Snom = 0 !"                   
          else 
            if result[:tr_losses_pkz_formula] != "" then result[:tr_losses_pkz_formula] += " + "  end
            if result[:tr_losses_rkz_formula] != "" then result[:tr_losses_rkz_formula] += " + "  end              
            unless mpoint.four then
                result[:tr_losses_pkz_formula] += tritem.transformator.pkz.to_s + " * " + tau.to_s + " * (" + wa.to_s + " ^2 + " + wr.to_s + " ^2 ) / (" + tm.to_s + " ^2 * " + tritem.transformator.snom.to_s + " ^2 ) "
                result[:tr_losses_rkz_formula] += tritem.transformator.qkz.to_s + " * " + tau.to_s + " * (" + wa.to_s + " ^2 + " + wr.to_s + " ^2 ) / (" + tm.to_s + " ^2 * " + tritem.transformator.snom.to_s + " ^2 ) "
                tr_losses_pkz += tritem.transformator.pkz * tau * (wa ** 2 + wr ** 2) / ((tm ** 2) * ((tritem.transformator.snom) ** 2))
                tr_losses_rkz += tritem.transformator.qkz * tau * (wa ** 2 + wr ** 2) / ((tm ** 2) * ((tritem.transformator.snom) ** 2))
            else
                result[:tr_losses_pkz_formula] += tritem.transformator.pkz.to_s + " * 1.15 ^2 * (" + wa.to_s + " ^2 + " + wr.to_s + " ^2 ) / (" + workt.to_s + " * " + tritem.transformator.snom.to_s + " ^2 ) "
                result[:tr_losses_rkz_formula] += tritem.transformator.qkz.to_s + " * 1.15 ^2 * (" + wa.to_s + " ^2 + " + wr.to_s + " ^2 ) / (" + workt.to_s + " * " + tritem.transformator.snom.to_s + " ^2 ) "
                tr_losses_pkz += tritem.transformator.pkz * 1.15 * 1.15 * (wa ** 2 + wr ** 2) / ((workt) * ((tritem.transformator.snom) ** 2))
                tr_losses_rkz += tritem.transformator.qkz * 1.15 * 1.15 * (wa ** 2 + wr ** 2) / ((workt) * ((tritem.transformator.snom) ** 2))                
            end                             
          end
          unless mpoint.four then
            tr_losses_rxx += (((tritem.transformator.i0 ** 2) * (tritem.transformator.snom ** 2) / 10000 - tritem.transformator.pxx ** 2) ** 0.5) * workt
            if result[:tr_losses_rxx_formula] != "" then result[:tr_losses_rxx_formula] += " + "  end
            result[:tr_losses_rxx_formula] += " (" + tritem.transformator.i0.to_s + " ^2 * " + tritem.transformator.snom.to_s + " ^2  / 10000 - " + tritem.transformator.pxx.to_s + " ^2 ) ^0.5 * " + workt.to_s
          else
            if result[:tr_losses_rxx_formula] != "" then result[:tr_losses_rxx_formula] += " + "  end
            result[:tr_losses_rxx_formula] += "наш трансформатор"
          end           
        end  # tr.each
        tr_losses_pxx = result[:tr_losses_pxx] = tr_losses_pxx.round(4)
        tr_losses_pkz = result[:tr_losses_pkz] = tr_losses_pkz.round(4)
        tr_losses_rxx = result[:tr_losses_rxx] = tr_losses_rxx.round(4)
        tr_losses_rkz = result[:tr_losses_rkz] = tr_losses_rkz.round(4)
        tr_losses_p = result[:tr_losses_p] = tr_losses_pxx + tr_losses_pkz
        result[:tr_losses_p_formula] = tr_losses_pxx.to_s + " + " + tr_losses_pkz.to_s 
        tr_losses_r = result[:tr_losses_r] = tr_losses_rxx + tr_losses_rkz
        result[:tr_losses_r_formula] = tr_losses_rxx.to_s + " + " + tr_losses_rkz.to_s  
        result[:ttaus] = ttaus            
      end  # if tr.count
      # линии         
      ln  = mpoint.vlnparams.where("f = 'true'") 
      ln_losses = ln_losses_ng = ln_losses_kr = 0.0      
      if ln.count != 0 && workt != 0 then
        if mpoint.voltcl == 0 then
          flash[:warning] = "Невозможно рассчитать потери в линии для #{mpoint.name}, т.к. voltcl = 0 !" 
        else               
          result[:ln_losses_ng_formula] = ''
          ln.each do |lnitem|
            if !lnitem.unom.nil? and lnitem.unom != 0 then unom = lnitem.unom else unom = mpoint.voltcl end  
            if result[:ln_losses_ng_formula] != '' then result[:ln_losses_ng_formula] += " + " end
            mpcount = Vmpointslnparam.where("line_id = ? and id != ?", lnitem.line_id, lnitem.mpoint_id).count
            lwa = wa  
            lwr = wr
            if mpcount > 0 then
              related_lines = Vmpointslnparam.where("line_id = ? and id != ?", lnitem.line_id, lnitem.mpoint_id)
              related_lines.each do |rlnitem|
                related_energies = one_mp_indicii(rlnitem.id, @ddate_b, @ddate_e, @ddate_mb, @ddate_me)
                if related_energies[:mvnum] == 2 then 
                    lwa += related_energies[:wa_without_wasub] 
                    lwr += related_energies[:wr]
                end    
              end  
            end    
            ln_losses_ng += ( lnitem.r * (lnitem.k_f ** 2) * (lwa ** 2 + lwr ** 2) / (1000 * ((unom) ** 2) * workt) ).round(4)
            result[:ln_losses_ng_formula] += "#{lnitem.r} * #{lnitem.k_f} ^2 * (#{lwa} ^2 + #{lwr} ^2) / (1000 * #{unom} ^2 * #{workt}) "
            if mpcount > 0 then
              k = (wa + wr) / (lwa + lwr)
              ln_losses_ng = (ln_losses_ng * k).round(4)
              result[:ln_losses_ng_formula] += " * #{k.round(4)}"
            end
          end
          result[:ln_losses_ng] = ln_losses_ng     
          ln_losses_kr = result[:ln_losses_kr] = ln_losses_kr.round(4)
          ln_losses = result[:ln_losses] = ln_losses_ng + ln_losses_kr
          result[:ln_losses_formula] = "#{ln_losses_ng} + #{ln_losses_kr}"              
        end
      end  # if ln.count
      # cos fi with losses           
      if wa >= 10000 and not(mpoint.fct) and mpoint.voltcl<=10 then
           wal = result[:wal] = wa + waliv + tr_losses_p + ln_losses
           result[:wal_formula] = wa.to_s + " + #{waliv} + " + tr_losses_p.to_s + " + " + ln_losses.to_s
           wrl = result[:wrl] = wri + tr_losses_r
           result[:wrl_formula] = wri.to_s + " + " + tr_losses_r.to_s
           wrcf = result[:wrcf] = wrc - tr_losses_r
           result[:wrcf_formula] = wrc.to_s + " - " + tr_losses_r.to_s           
           cosf = result[:cosf] = (wal / ((wal ** 2 + wrl ** 2) ** 0.5)).round(4)
           result[:cosf_formula] = wal.to_s + " / (( " + wal.to_s + "^2 + " + wrl.to_s + "^2) ^0.5)"
           if mpoint.voltcl == 0.4 then  tgficonst = 0.426 else tgficonst = 0.567 end
           wrio = result[:wrio] = (wal * tgficonst).round(4)
           result[:wrio_formula] = " #{wal} * #{tgficonst} "
           if wrio < wrl then
             wrif = result[:wrif] = wrl - wrio
             result[:wrif_formula] = wrl.to_s + " - " + wrio.to_s
           else
             wrif = result[:wrif] = 0.0
             result[:wrif_formula] = "0.0"
           end
           cti = ctc = 0.0
           unless mpoint.fctc then
             unless mpoint.fmargin then                     
               result[:consumtehc] = ctc = ((wrc) * 0.1).round(4)
               result[:consumtehc_formula] = wrc.to_s + " * 0.1"
             else
               result[:consumtehc] = ctc = if wrcf > 0 then ((wrcf) * 0.1).round(4) else 0.0 end
               result[:consumtehc_formula] = if wrcf > 0 then "#{wrcf} * 0.1" else "0.0" end
             end    
           end
           unless mpoint.fctl then 
             result[:consumtehi] = cti =((wrif ) * 0.1).round(4)
             result[:consumtehi_formula] = wrif.to_s + " * 0.1"              
           end
           ct = result[:consumteh] = cti + ctc
           result[:consumteh_formula] = "#{cti} + #{ctc}"    
       end #if wa               
     end # if mvnum  
   result
   end
  
   def indexview
    if params[:filter] then
        @@qmesubstation = @qmesubstation = params[:qmesubstation].to_s
        @@qcompany = @qcompany = params[:qcompany].to_s
        @@qregion = @qregion = params[:qregion].to_s
        @@qfilial = @qfilial = params[:qfilial].to_s
        @@qfurnizor = @qfurnizor = params[:qfurnizor].to_s
        @data_for_search = @@data_for_search = '' 
    else
        if params[:search] then
            @@data_for_search = @data_for_search = params[:q].to_s
            @@qmesubstation = @@qcompany = @@qregion = @@qfilial = @@qfurnizor = ''            
        else
            @data_for_search = @@data_for_search
        end
        @qmesubstation = @@qmesubstation
        @qcompany = @@qcompany
        @qregion = @@qregion
        @qfilial = @@qfilial
        @qfurnizor = @@qfurnizor
    end
    @filter = 0      
    company_list = @flr.vallmpoints.pluck(:company_id).uniq
    if @data_for_search.empty? then
      if @qmesubstation.empty? and @qcompany.empty? and @qregion.empty? and @qfilial.empty? and @qfurnizor.empty? then   
       company_list = @flr.vallmpoints.where(if @fpr < 6 then "filial_id = ?" else "furnizor_id = ?" end, @flr.id).pluck(:company_id).uniq
       @filter = 0
      else
       @filter = 1         
       company_list = @flr.vallmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                               "and (?='' or mesubstation_name=?) and (?='' or region_name=?) and (?='' or company_shname=?) and (?='' or filial_name=?)" +
                               " and (?='' or furnizor_name=?)", 
                               @flr.id, @qmesubstation, @qmesubstation, @qregion, @qregion, @qcompany, @qcompany, @qfilial, @qfilial, @qfurnizor, @qfurnizor).pluck(:company_id).uniq
      end  
    else
       @filter = 1
       @data_for_search = @data_for_search.upcase
       data_for_search = "%" + @data_for_search + "%"
       company_list = @flr.vallmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                               "and (upper(company_name||company_shname) like upper(?) "+ 
                               "or upper(cod||name) like upper(?) "+ 
                               "or upper(filial_name||region_name||furnizor_name) like upper(?) "+ 
                               "or upper(mesubstation_name) like upper(?)) ", 
                               @flr.id, data_for_search, data_for_search, data_for_search, data_for_search).pluck(:company_id).uniq
    end
    @companies = (Company.order(shname: :asc).find(company_list))     
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
  
  def indexviewall
    #-----------------------------------------
    if params[:search] then
       @@company_search = @data_for_search = params[:company_search].to_s        
    else
       @data_for_search = @@company_search
    end
    if @data_for_search.empty? then
       @companies = Company.all.order(shname: :asc, name: :asc, cod: :asc, id: :asc) 
    else
       @data_for_search = @data_for_search.upcase
       data_for_search = "%" + @data_for_search + "%"
       @companies = Company.where(" upper(cod) like upper(?) or upper(name) like upper(?) or upper(shname) like upper(?) ", 
                               data_for_search, data_for_search, data_for_search).order(shname: :asc, name: :asc, cod: :asc, id: :asc)
    end   
    #-----------------------------------------
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
      if params[:flr_id].nil? then
        redirect_to companies_all_path(:page => @page)         
      else
        redirect_to companies_index_path(:id => params[:flr_id], :page => @page) 
      end    
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
    t = params[:cod]
    t = t.lstrip
    t = t.rstrip     
    company.cod = t 
    t = params[:comment]
    t = t.lstrip
    t = t.rstrip   
    company.comment = t
    company.f = if params[:f].nil? then false else true end  
    company    
  end        
     
end
