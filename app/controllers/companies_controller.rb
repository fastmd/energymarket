class CompaniesController < ApplicationController
before_action :check_user
before_action :redirect_cancel, only: [:create, :update] 
  
  def helpmpoint
    @pagename = 'Справка-Точки учета'
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end
    @page = params[:page]
    unless params[:cp_id].nil? then
      @company = Company.find(params[:cp_id])
    end  
  end
  
  def new
  end
  
  def all    
    if params[:cp_id].nil? then
      @company = Company.new
    else
      @company = Company.find(params[:cp_id])
      params[:cp_id] = nil
    end 
    indexviewall(1)  
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
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода.#{@company.errors.full_messages}"       
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
  #  if params[:cp_id].nil? then
  #    @company = Company.new
  #  else
  #    @company = Company.find(params[:cp_id])
  #    params[:cp_id] = nil
  #  end  
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
    #-------------------------------
    @flag = params[:flag]
    #-------------------------------
    @cp = Company.find(params[:id])
    @mpoint = @cp.mpoints.build
    if @fpr < 6  then  
      @flr = Filial.find(params[:flr_id]) 
    else 
      @flr =  Furnizor.find(params[:flr_id])
      @mpoint.furnizor_id = params[:flr_id] 
    end 
    @mp =  Vallmpointsproperty.where(if @fpr < 6 then "filial_id = ? and company_id = ?" else "furnizor_id = ? and company_id = ?" end, @flr.id, @cp.id).order(name: :asc, created_at: :asc)
    #-------------------------------
    if params[:mproperty_id] then 
      @mproperty = Mproperty.find(params[:mproperty_id]) 
    else 
      @mproperty = Mproperty.new
    end
    #------------------------------- 
    @companies = Company.where("id = ? and f = true", @cp.id)  
    @mpoints = Vallmpoint.where(if @fpr < 6 then "filial_id = ? and company_id = ?" else "furnizor_id = ? and company_id = ? and f = true" end, @flr.id, @cp.id).order(name: :asc, created_at: :asc)  
    gon.mpoints = @mpoints
    #-------------------------------
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
    @id = params[:cp_id]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr = Filial.find(params[:flr_id]) else @flr = Furnizor.find(params[:flr_id]) end
    @ddate_b = Date.new(2000, 1, 1)  
    @ddate_e = Date.new(3000, 1, 1)   
    @mvalues = Vmpointsmetersvalue.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + "AND company_id = ? AND (actdate between ? AND  ?)", @flr.id, @id, @ddate_b, @ddate_e).order(:id => :asc, actdate: :desc, relevance_date: :desc, mvalue_updated_at: :desc)  
  end  
 
  def mtreport
    @id = params[:cp_id]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr = Filial.find(params[:flr_id]) else @flr = Furnizor.find(params[:flr_id]) end
    @meters = Vmpointsmeter.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + " AND company_id = ?", @flr.id, @id).order(:name, :id, :relevance_date, :updated_at)
  end  
 
  def paramreport
    @id = params[:cp_id]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr = Filial.find(params[:flr_id]) else @flr = Furnizor.find(params[:flr_id]) end 
    @trp = Vmpointstrparam.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + " AND company_id = ?", @flr.id, @id).order(:name, :id, :tr_id, :updated_at)
    @lnp = Vmpointslnparam.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + " AND company_id = ?", @flr.id, @id).order(:name, :id, :ln_id, :updated_at)
    @tau = Tau.all    
  end  
  
  def onempreport
    @debug = nil
    @page = params[:page]
    @id = params[:id]
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end    
    # month
    monthforreports
    @mp = Mpoint.find(params[:mp_id])
    @cp = @mp.company  
    # title
    @lista_title = []
    @lista_title << "Расчет потребления и потерь для потребителя #{@cp.name}"
    @lista_title << "точка учета #{@mp.cod} #{@mp.name} #{@mp.voltcl} Î #{@mp.meconname} F #{@mp.clconname} п/ст #{@mp.mesubstation.name}"
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
    dddate_b = @energies[:dddate_b]
    dddate_e = @energies[:dddate_e]
    @mproperty = Mproperty.where("mpoint_id = ? and propdate <= ? and f = true", @mp.id, dddate_b).order(propdate: :asc, updated_at: :asc).last
    if @mproperty.nil? then
      @mproperty = Mproperty.new
      @mproperty.mpoint_id = @mp.id
      @mproperty.voltcl = @mp.voltcl
    end     
    #render inline: "<%= params.inspect %><br><br><%= @mp.inspect %><br><br><%= @mproperty.inspect %><br><br>" and return 
    @lnp = @mp.vlnparams.where("(? < condate_end) AND (? > condate)", dddate_b, dddate_e).order(:condate,:line_id)
    @condates = @mp.vlnparams.select(:condate).distinct.where("(? < condate_end) AND (? > condate) AND (condate > ?)", dddate_b, dddate_e, dddate_b).pluck(:condate)
    @condates += @mp.vlnparams.select(:condate_end).distinct.where("(? < condate_end) AND (? > condate) AND (condate_end < ?)", dddate_b, dddate_e, dddate_e).pluck(:condate_end)
    @condates << dddate_b
    @condates << dddate_e
    @condates.uniq!
    @condates.sort!    
    @tau = Tau.all
    #render inline: "<%= @llnparam.inspect %><br><br><%= @lcondate.inspect %><br><br><%= @ldddate_e.inspect %><br><br><%= @dt.inspect %><br><br>" and return 
  end
   
  def reports #kotik s summoi
    @page = params[:page]
    @id = params[:id]
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end
    @vc = params[:vc]
    @va = params[:va]     
    # month   
    monthforreports
    # title
    @lista_title = []
    @lista_title << "LISTA de calcul a intrarii energiei electrice pentru"
    @lista_title << ("consumatori  alimentați direct de la stații  electrice Î.S. ”Moldelectrica”" + (if @fpr < 6 then " filiala RETÎ" else " furnizorul" end) + " #{@flr.name}") 
    @lista_title << "pentru luna #{@luna} anul #{@ddate.year}"
    @title00 = ['№',1,2],['№ locului de consum',1,2],['Nume client',1,2],['RRE,SE si liniilor',1,2],['Conexiunea',1,2],['№ contor.',1,2],
              ['Data citirii',1,2],['Indicaţii luna precedenta',3,1],
              ['Data citirii',1,2],['Indicaţii luna curenta',3,1],
              ['Coeficient contor',1,2],['ENERGIA, kWh',3,1],
              ['Pierderi LEA, kWh',2,1],['Pierderi trans, kWh',1,2],["Consum\n Tehnologic,\n kWh inductiv",1,2],["Consum\n Tehnologic, kWh\n capacitiv",1,2]
    @title01 = ['Activ',1,1],['Reactiv L',1,1],['Reactiv C',1,1],['Activ',1,1],['Reactiv L',1,1],['Reactiv C',1,1],['Activ',1,1],['Reactiv L',1,1],['Reactiv C',1,1],['Consumator',1,1],['ME',1,1]            
    @title0 = ['','','','','','','','Indicaţii luna precedenta','','Indicaţii luna curenta','','ENERGIA, kWh','Pierderi LEA, kWh','','','']
    @title1 = ['№','№ locului de consum','Nume client','RRE,SE si liniilor','Conexiunea','№ contor.',
              'Data citirii','Indicatii activ','Indicatii reactiv L','Indicatii reactiv C',
              'Data citirii','Indicatii activ','Indicatii reactiv L','Indicatii reactiv C',
              'Coeficient contor','ENERGIA, kWh activ','ENERGIA, kWh reactiv L','ENERGIA, kWh reactiv C',
              'Pierderi LEA cons, kWh','Pierderi LEA ME, kWh','Pierderi trans, kWh','Consum Tehnologic, kWh inductiv',"Consum Tehnologic, kWh capacitiv"]
    titleforreports
    # report init
    @report = Array[]
    # filter
    dataforfilterselect
    filtertocookies
    cookiesforreports
    mpoints = mpointsforreports
    #report    
      nr = 0
      cp = nil
      enrgsums = {}
        # mpoints 
        if mpoints.count == 0 then
          flash[:warning] = "Нет данных для отчета. Потребители не имеют точек учета." 
        else
          mpoints.each do |mp|
           if mp.cod != 0 then #test for fake mpoint 
           if (@flr.class.name.demodulize == 'Filial' && mp.mesubstation.filial_id == @flr.id) || (@flr.class.name.demodulize == 'Furnizor' && mp.furnizor_id == @flr.id)  then
            # report rind
            nr += 1
            report_rind = [nr,"#{mp.cod}","#{mp.company_name}","#{mp.mesubstation.name}",if mp.meconname.count("a-zA-Zа-яА-ЯîÎ") > 0 then mp.meconname else"#{mp.voltcl} Î #{mp.meconname} F" end,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
            # indicii si energie        
            energies = one_mp_indicii(mp.id, @ddate_b, @ddate_e, @ddate_mb, @ddate_me)
            indicii = energies[:indicii]
            if indicii.nil? then
              report_rind[@title1.count] = 1
            else 
              indicii.each do |ind|
                report_rind[5]  = ind[:meternum]
                unless ind[:date0].nil? then report_rind[6]  = (ind[:date0]).to_formatted_s(:day_month_year) end
                unless ind[:ind0_activ].nil? then report_rind[7]  = ind[:ind0_activ] end
                unless ind[:ind0_reactivl].nil? then report_rind[8]  = ind[:ind0_reactivl] end
                unless ind[:ind0_reactivc].nil? then report_rind[9]  = ind[:ind0_reactivc] end
                unless ind[:date1].nil? then report_rind[10]  = (ind[:date1]).to_formatted_s(:day_month_year) end
                unless ind[:ind1_activ].nil? then report_rind[11]  = ind[:ind1_activ] end
                unless ind[:ind1_reactivl].nil? then report_rind[12]  = ind[:ind1_reactivl] end
                unless ind[:ind1_reactivc].nil? then report_rind[13]  = ind[:ind1_reactivc] end
                unless ind[:koef].nil? then report_rind[14]  = ind[:koef].round end
                unless ind[:wa].nil? then report_rind[15]  = ind[:wa] end
                unless ind[:wri].nil? then report_rind[16]  = ind[:wri].round end
                unless ind[:wrc].nil? then report_rind[17]  = ind[:wrc].round end
                if indicii.count != 1 or (!energies[:wasub].nil? and energies[:wasub] != 0) then           
                  @report << report_rind[0..@title1.count]                
                  report_rind = Array.new((@title1.count+1), nil)
                end
              end  
              # pierderi   
              losses = one_mp_losses(mp.id, energies)
              # report
              unless energies[:wa_without_wasub_with_undercount].nil? then 
                report_rind[15]  = energies[:wa_without_wasub_with_undercount]
                if enrgsums[:wa_without_wasub_with_undercount].nil? then 
                  enrgsums[:wa_without_wasub_with_undercount] = energies[:wa_without_wasub_with_undercount] 
                else 
                  enrgsums[:wa_without_wasub_with_undercount] += energies[:wa_without_wasub_with_undercount] 
                end 
              end
              unless energies[:wri].nil? then 
                report_rind[16]  = energies[:wri]
                if enrgsums[:wri].nil? then enrgsums[:wri] = energies[:wri] else enrgsums[:wri] += energies[:wri] end 
              end
              unless energies[:wrc].nil? then 
                report_rind[17]  = energies[:wrc]
                if enrgsums[:wrc].nil? then enrgsums[:wrc] = energies[:wrc] else enrgsums[:wrc] += energies[:wrc] end 
              end
              unless losses.nil? then
                unless losses[:ln_losses].nil? then 
                  report_rind[18]  = losses[:ln_losses]
                  if enrgsums[:ln_losses].nil? then enrgsums[:ln_losses] = losses[:ln_losses] else enrgsums[:ln_losses] += losses[:ln_losses] end 
                end
                unless losses[:ln_me_losses].nil? then 
                  report_rind[19]  = losses[:ln_me_losses]
                  if enrgsums[:ln_me_losses].nil? then enrgsums[:ln_me_losses] = losses[:ln_me_losses] else enrgsums[:ln_me_losses] += losses[:ln_me_losses] end 
                end                
                unless losses[:tr_losses_p].nil? then 
                  report_rind[20]  = losses[:tr_losses_p]
                  if enrgsums[:tr_losses_p].nil? then enrgsums[:tr_losses_p] = losses[:tr_losses_p] else enrgsums[:tr_losses_p] += losses[:tr_losses_p] end  
                end                
                unless losses[:consumtehi].nil? then 
                  report_rind[21]  = losses[:consumtehi]
                  if enrgsums[:consumtehi].nil? then enrgsums[:consumtehi] = losses[:consumtehi] else enrgsums[:consumtehi] += losses[:consumtehi] end  
                end
                unless losses[:consumtehc].nil? then 
                  report_rind[22]  = losses[:consumtehc]
                  if enrgsums[:consumtehc].nil? then enrgsums[:consumtehc] = losses[:consumtehc] else enrgsums[:consumtehc] += losses[:consumtehc] end  
                end
              end # losses null               
            end # indicii null
            @report << report_rind[0..@title1.count]  
          end 
         end  #test for fake mpoint         
        end  # mpoints each
        @report << ['∑','În total:',nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,enrgsums[:wa_without_wasub_with_undercount],enrgsums[:wri],enrgsums[:wrc],enrgsums[:ln_losses],enrgsums[:ln_me_losses],enrgsums[:tr_losses_p],enrgsums[:consumtehi],enrgsums[:consumtehc],3] 
       end  # mpoints.count  
    respond_to do |format|
      format.html
      format.pdf { send_data ListaReports.new.to_pdf(@flr,@report,@luna,@ddate,@luna_b,@luna_e), :type => 'application/pdf', :filename => "lista.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="lista.xlsx"' }
    end  
  end #kotik s summoi
 
  def simplereports #neznaika
    #render inline: "<%= params.inspect %><br><br>" and return 
    if ((params.has_key?(:pret)) and !params[:pret].empty? and !params[:pret].nil? and params[:pret] != '') then 
      @pret = 1
      pret = 4      
    else  
      pret = 0
      @pret = nil 
    end
    @page = params[:page]
    @id = params[:id] 
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end
    @vc = params[:vc]
    @va = params[:va]        
    # month   
    monthforreports
    # title
    @lista_title = []
    @lista_title << "LISTA de calcul a intrarii energiei electrice pentru"
    @lista_title << ("consumatori  alimentați direct de la stații  electrice Î.S. ”Moldelectrica”" + (if @fpr < 6 then " filiala RETÎ" else " furnizorul" end) + " #{@flr.name}") 
    @lista_title << "pentru luna #{@luna} anul #{@ddate.year}"
    @title1 = ['№','RRE,SE si liniilor','Punctul de evidenta','','№ contor.',"Indicatii \n #{@luna_e}","Indicatii \n #{@luna_b}",'Diferenta indicat.','Coeficient contor.','ENERGIE, kWh','Note']
    titleforreports
    # report init
    @report = Array[]
    # filter
    dataforfilterselect
    filtertocookies
    cookiesforreports
    mpoints = mpointsforreports    
    # mpoints
    if mpoints.count == 0 then
       flash[:warning] = "Нет данных для отчета. Потребители не имеют точек учета." 
    else 
      nr = 0
      enrgsums = {}
      cp = nil #current company
      mpoints.each do |mp|
       if mp.cod != 0 then #test for fake mpoint 
        # report rind
        if cp != mp.company_id then
          cp = mp.company_id
          nr += 1
          report_rind = [nr,"#{mp.company_name}",nil,nil,nil,nil,nil,nil,nil,nil,nil,2]
          @report << report_rind[0..@title1.count] 
        end
        if (@flr.class.name.demodulize == 'Filial' && mp.mesubstation.filial_id == @flr.id) || (@flr.class.name.demodulize == 'Furnizor' && mp.furnizor_id == @flr.id)  then
            # report rind
            report_rind = [nil,"(#{mp.mesubstation.name})",if mp.meconname.count("a-zA-Zа-яА-ЯîÎ") > 0 then mp.meconname else"#{mp.voltcl} Î #{mp.meconname} F" end,"#{mp.clconname}",nil,nil,nil,nil,nil,nil,nil,nil]
            # indicii si energie        
            energies = one_mp_indicii(mp.id, @ddate_b, @ddate_e, @ddate_mb, @ddate_me)
            #render inline: "<%= params.inspect %><br><br><%= @temp.inspect %><br><br>" and return
            indicii = energies[:indicii]
            #@ttt = indicii
            #render inline: "<%= @ttt.inspect %><br><br><%= @temp.inspect %><br><br>" and return
            if indicii.nil? then
              report_rind[@title1.count] = 1
              @report << report_rind[0..@title1.count] 
            else   
              # report
              indicii.each do |inditem|
                report_rind[@title1.count] = 1
                unless inditem[:meternum].nil? then report_rind[4] = inditem[:meternum] end
                unless inditem[:date1].nil? then 
                  report_rind[5] = (inditem[:date1]).to_formatted_s(:day_month_year)
                  report_rind[@title1.count] = nil 
                end  
                unless inditem[:date0].nil? then report_rind[6] = (inditem[:date0]).to_formatted_s(:day_month_year) end
                unless inditem[:dt].nil? then report_rind[7] = inditem[:dt] end     
                @report << report_rind[0..@title1.count]
                report_rind[0..4] = [nil,nil,nil,nil,nil]
                unless inditem[:date1].nil? then
                  @report << [nil,nil,if mp.meconname.count("a-zA-Zа-яА-ЯîÎ") > 0 then mp.meconname else "#{mp.voltcl} Î #{mp.meconname} F" end + " a/pr", nil,nil,inditem[:ind1_180],inditem[:ind0_180],inditem[:dind_180],roundconfpret(inditem[:koef], pret),roundconfpret(inditem[:enrg_180], pret),nil,nil]
                  @report << [nil,nil,if mp.meconname.count("a-zA-Zа-яА-ЯîÎ") > 0 then mp.meconname else "#{mp.voltcl} Î #{mp.meconname} F" end + " a/liv",nil,nil,inditem[:ind1_280],inditem[:ind0_280],inditem[:dind_280],roundconfpret(inditem[:koef], pret),roundconfpret(inditem[:enrg_280], pret),nil,nil]
                  @report << [nil,nil,if mp.meconname.count("a-zA-Zа-яА-ЯîÎ") > 0 then mp.meconname else "#{mp.voltcl} Î #{mp.meconname} F" end + " r/pr", nil,nil,inditem[:ind1_380],inditem[:ind0_380],inditem[:dind_380],roundconfpret(inditem[:koef], pret),roundconfpret(inditem[:enrg_380], pret),nil,nil]
                  @report << [nil,nil,if mp.meconname.count("a-zA-Zа-яА-ЯîÎ") > 0 then mp.meconname else "#{mp.voltcl} Î #{mp.meconname} F" end + " r/liv",nil,nil,inditem[:ind1_480],inditem[:ind0_480],inditem[:dind_480],roundconfpret(inditem[:koef], pret),roundconfpret(inditem[:enrg_480], pret),nil,nil]
                end
              end
              unless energies[:wasub].nil? then 
                if enrgsums[:wasub].nil? then enrgsums[:wasub] = energies[:wasub] else enrgsums[:wasub] += energies[:wasub] end
                report_rind = [nil,"Consum subabonat, kWh",nil,nil,nil,nil,nil,nil,nil,roundconfpret(energies[:wasub], pret),nil,nil]
                @report << report_rind[0..@title1.count]                  
              end              
              unless energies[:undercount].nil? then 
                if enrgsums[:undercount].nil? then enrgsums[:undercount] = energies[:undercount] else enrgsums[:undercount] += energies[:undercount] end
              end
              unless energies[:wa].nil? then 
                if enrgsums[:wa].nil? then enrgsums[:wa] = energies[:wa] else enrgsums[:wa] += energies[:wa] end
                if enrgsums[:w].nil? then enrgsums[:w] = energies[:wa_without_wasub_with_undercount]  else enrgsums[:w] += energies[:wa_without_wasub_with_undercount] end   
              end
              unless energies[:waliv].nil? then
                if enrgsums[:waliv].nil? then enrgsums[:waliv] = energies[:waliv] else enrgsums[:waliv] += energies[:waliv] end
            #    if enrgsums[:w].nil? then enrgsums[:w] = energies[:waliv]  else enrgsums[:w] += energies[:waliv] end 
              end
              consum_pe_mp = energies[:wa_without_wasub_with_undercount]               
              # pierderi   
              losses = one_mp_losses(mp.id, energies)             
              # report Pierderi               
              unless losses.nil? then
                # report Pierderi LEA                
                unless losses[:ln_losses].nil? then
                  if enrgsums[:losses].nil? then enrgsums[:losses] = losses[:ln_losses] else enrgsums[:losses] += losses[:ln_losses]  end
                  consum_pe_mp += losses[:ln_losses]
                end                
                report_rind = [nil,"Pierderi LEA (cons.), kWh",nil,nil,nil,nil,nil,nil,nil,roundconfpret(losses[:ln_losses], pret),nil,nil]                  
                #render inline: "<%= @report.inspect %><br><br><%= 'cucu' %><br><br>" and return                          
                @report << report_rind[0..@title1.count]
                # report Pierderi LEA - ME               
                unless losses[:ln_me_losses].nil? then
                  if enrgsums[:me_losses].nil? then enrgsums[:me_losses] = losses[:ln_me_losses] else enrgsums[:me_losses] += losses[:ln_me_losses]  end
                  consum_pe_mp -= losses[:ln_me_losses]
                end                
                report_rind = [nil,"Pierderi LEA (ME), kWh",nil,nil,nil,nil,nil,nil,nil,roundconfpret(losses[:ln_me_losses], pret),nil,nil]
                @report << report_rind[0..@title1.count]                
                # report Pierderi transf
                unless losses[:tr_losses_p].nil? then
                  if enrgsums[:losses].nil? then enrgsums[:losses] = losses[:tr_losses_p] else enrgsums[:losses] += losses[:tr_losses_p] end 
                  consum_pe_mp += losses[:tr_losses_p]
                end                                        
                  report_rind = [nil,"Pierderi transf, kWh",nil,nil,nil,nil,nil,nil,nil,roundconfpret(losses[:tr_losses_p], pret),nil,nil]
                  @report << report_rind[0..@title1.count]  
                # report Consum Tehnologic inductiv                  
                unless losses[:consumtehi].nil? then
                  if enrgsums[:consumteh].nil? then enrgsums[:consumteh] = losses[:consumtehi] else enrgsums[:consumteh] += losses[:consumtehi] end
                  consum_pe_mp += losses[:consumtehi]
                end                       
                  report_rind = [nil,"Consum Tehnologic inductiv",nil,nil,nil,nil,nil,nil,nil,roundconfpret(losses[:consumtehi], pret),nil,nil]
                  @report << report_rind[0..@title1.count]               
                # report Consum Tehnologic capacitiv
                unless losses[:consumtehc].nil? then                
                  if enrgsums[:consumteh].nil? then enrgsums[:consumteh] = losses[:consumtehc] else enrgsums[:consumteh] += losses[:consumtehc]  end
                  consum_pe_mp += losses[:consumtehc]
                end                     
                  report_rind = [nil,"Consum Tehnologic capacitiv",nil,nil,nil,nil,nil,nil,nil,roundconfpret(losses[:consumtehc], pret),nil,nil]   
                  @report << report_rind[0..@title1.count]    
              end # losses.nil?
              unless consum_pe_mp.nil? then
                report_rind = [nil,"Consum e/e + pierderi + CT",nil,nil,nil,nil,nil,nil,nil,roundconfpret(consum_pe_mp, pret),nil,nil]   
                @report << report_rind[0..@title1.count]
              end             
            end # indicii null 
       end 
       end  #test for fake mpoint 
      end  #mpoints each 
      @report << ['∑','Consum subabonatului',nil,nil,nil,nil,nil,nil,nil,roundconfpret(enrgsums[:wasub], pret),nil,4]
      @report << ['∑','Consum nefacturat',nil,nil,nil,nil,nil,nil,nil,roundconfpret(enrgsums[:undercount], pret),nil,4]
      @report << ['∑','Suma primirii',nil,nil,nil,nil,nil,nil,nil,roundconfpret(enrgsums[:wa], pret),nil,4]      
      @report << ['∑','Suma livrarii',nil,nil,nil,nil,nil,nil,nil,roundconfpret(enrgsums[:waliv], pret),nil,4]
      @report << ['∑','În total, consum e/e (prim.+nef.-sub.)',nil,nil,nil,nil,nil,nil,nil,roundconfpret(enrgsums[:w], pret),nil,4]
      @report << ['∑','Consum Tehnologic',nil,nil,nil,nil,nil,nil,nil,roundconfpret(enrgsums[:consumteh], pret),nil,nil]                 
      @report << ['∑','Suma pierderi (consumator)',nil,nil,nil,nil,nil,nil,nil,roundconfpret(enrgsums[:losses], pret),nil,3]
      @report << ['∑','Suma pierderi (ME)',nil,nil,nil,nil,nil,nil,nil,roundconfpret(enrgsums[:me_losses], pret),nil,3]
      total_consum = (enrgsums[:w].nil? ? 0 : enrgsums[:w]) + (enrgsums[:consumteh].nil? ? 0 : enrgsums[:consumteh]) + (enrgsums[:losses].nil? ? 0 : enrgsums[:losses])
      @report << ['∑','Consum e/e + pierderi + CT',nil,nil,nil,nil,nil,nil,nil,roundconfpret(total_consum, pret),nil,4]        
    end  #mpoints.count
    respond_to do |format|
      format.html
      format.pdf { send_data ListaReports.new.to_pdf(@flr,@report,@luna,@ddate,@luna_b,@luna_e), :type => 'application/pdf', :filename => "lista.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="lista.xlsx"' }
    end  
  end #neznaika
 
  def regionreports #lamp
    @page = params[:page]
    @id = params[:id] 
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end
    @vc = params[:vc]
    @va = params[:va]       
    # month   
    monthforreports
    # title
    @lista_title = []
    @lista_title << "LISTA consumatorilor directi alimentati de la statiunile electrice Î.S. ”Moldelectrica”"
    @lista_title << ((if @fpr < 6 then " filiala RETÎ" else " furnizorul" end) + " #{@flr.name} pentru luna #{@luna} anul #{@ddate.year}") 
    @title1 = ['№','Statiunea Î.S. ”Moldelectrica” de unde este alimentat consumatorul','№ fider de unde este alimemtat TF al consumatorului',
               'Denumirea consumatorului','Wa, kWh',"Pierderi LEA cons., kWh","Pierderi LEA ME, kWh","Pierderile transformatorului, kWh",'Consum Tehnologic (CT), kWh']
    titleforreports
    # filter
    dataforfilterselect
    filtertocookies
    cookiesforreports
    mpoints = mpointsforreports                             
    # report init
    @report = Array[]
    enrgsums = {}
    nr = 0
    # mpoints
    region = ''
    if mpoints.count == 0 then
      flash[:warning] = "Нет данных для отчета. #{@flr.name} не имеет точек учета." 
    else
      mpoints.each do |mp|
       if mp.cod != 0 then #test for fake mpoint
        # report rind
        if region != mp.region_name then
          region = mp.region_name 
          @report << [nil,"FRED #{region}",nil,nil,nil,nil,nil,nil,nil,2]
        end
        nr += 1
        report_rind = [nr,"#{mp.mesubstation_name}",if mp.meconname.count("a-zA-Zа-яА-ЯîÎ") > 0 then mp.meconname else"#{mp.voltcl} Î #{mp.meconname} F" end,"#{mp.company_name}",nil,nil,nil,nil,nil,nil]
        # indicii si energie        
        energies = one_mp_indicii(mp.id, @ddate_b, @ddate_e, @ddate_mb, @ddate_me)
        indicii = energies[:indicii]
        if indicii.nil? then
           report_rind[@title1.count] = 1      
        else
           enrgsums = add_one_mp_indicii(energies, enrgsums)       
           # pierderi   
           losses = one_mp_losses(mp.id, energies)
           enrgsums = add_one_mp_losses(losses, enrgsums) 
           # report
           report_rind[4] = energies[:wa_without_wasub_with_undercount]   
           report_rind[5] = losses[:ln_losses]
           report_rind[6] = losses[:ln_me_losses]   
           report_rind[7] = losses[:tr_losses_p]
           report_rind[8] = losses[:consumteh]        
        end # indicii null
        @report << report_rind[0..@title1.count]  
       end  #test for fake mpoint       
      end  # mpoints each
      @report << ['∑',nil,nil,nil,enrgsums[:wa_without_wasub_with_undercount],enrgsums[:ln_losses],enrgsums[:ln_me_losses],enrgsums[:tr_losses_p],enrgsums[:consumteh],4]        
    end  # mpoints.count                                                     
  end #lamp
 
  def graphreports #holub cauta
    @page = params[:page]
    @id = params[:id] 
    if @fpr < 6 then  @flr =  Filial.find(params[:id]) else @flr =  Furnizor.find(params[:id]) end
    @vc = params[:vc]
    @va = params[:va] 
    @fwa = params[:fwa]
    @fwasimple = params[:fwasimple]
    @fsub = params[:fsub] 
    @fwr = params[:fwr]
    @fned = params[:fned]
    unless (@fwa or @fwr or @fned or @fwasimple or @fsub) then  
      @fwa = 1 
    end     
    # month   
    monthforreports
    # title
    @lista_title = []
    @lista_title << "Потребление"
    @lista_title << ("за период c #{@ddate.strftime('%m-%Y')} по #{@eddate_b.strftime('%m-%Y')}") 
    @title1 = ['№','Потребитель','П/ст','Фидер','ТУ']
    @title00 = ['№',1,2],['Потребитель',1,2],['П/ст',1,2],['Фидер',1,2],['ТУ',1,2]
    @title01 = [] 
    # filter
    dataforfilterselect
    filtertocookies
    cookiesforreports
    mpoints = mpointsforreports                             
    # report init
    @report = Array[]
    nc = if @fwr then 1 else 0 end + if @fwa then 1 else 0 end + if @fned then 1 else 0 end + if @fsub then 1 else 0 end + if @fwasimple then 1 else 0 end
    if nc == 0 then nc = 1 end 
    #-------------
    while @eddate_b >= @ddate_b do
      @title00 << ["#{@ddate_b.strftime('%m-%Y')}",nc,1]
      if @fwasimple then 
        @title01 << ["Wa",1,1]
        @title1 << "Wa #{@ddate_b.strftime('%m-%Y')}" 
      end
      if @fsub then 
        @title01 << ["Суб.",1,1]
        @title1 << "Потребление субабонента #{@ddate_b.strftime('%m-%Y')}" 
      end           
      if @fned then 
        @title01 << ["Нед.",1,1]
        @title1 << "Недоучет #{@ddate_b.strftime('%m-%Y')}" 
      end        
      if @fwa then 
        @title01 << ["Wa(итог)",1,1]
        @title1 << "Wa с недоучетом и субабонентом #{@ddate_b.strftime('%m-%Y')}" 
      end
      if @fwr then 
        @title01 << ["Wr",1,1]
        @title1 << "Wr #{@ddate_b.strftime('%m-%Y')}" 
      end  
      enrgsums = {}
      nr = 0
      # mpoints
      if mpoints.count == 0 then
        flash[:warning] = "Нет данных для отчета. #{@flr.name} не имеет точек учета." 
      else
        mpoints.each do |mp|
         if mp.cod != 0 then #test for fake mpoint
          # report rind
          report_rind = @report[nr]        
          nr += 1
          if report_rind.nil? then report_rind = [nr,"#{mp.company_name}","#{mp.mesubstation_name}",if mp.meconname.count("a-zA-Zа-яА-ЯîÎ") > 0 then mp.meconname else "#{mp.voltcl} Î #{mp.meconname} F" end, "#{mp.clconname}"] end
          # indicii si energie        
          energies = one_mp_indicii(mp.id, @ddate_b, @ddate_e, @ddate_mb, @ddate_me)
          indicii = energies[:indicii]
          if indicii.nil? then
             if @fwasimple then report_rind << nil end 
             if @fsub then report_rind << nil end 
             if @fned then report_rind << nil end             
             if @fwa then report_rind << nil end
             if @fwr then report_rind << nil end   
          else
             enrgsums = add_one_mp_indicii(energies, enrgsums)       
             # pierderi   
             #losses = {} #one_mp_losses(mp.id, energies)
             #enrgsums = add_one_mp_losses(losses, enrgsums) 
             # report
             if @fwasimple then report_rind << energies[:wa] end
             if @fsub then report_rind << energies[:wasub] end
             if @fned then report_rind << energies[:undercount] end 
             if @fwa then report_rind << energies[:wa_without_wasub_with_undercount] end
             if @fwr then report_rind << (energies[:wr] ? energies[:wr].round(1) : energies[:wr]) end    
             #report_rind << losses[:ln_losses]   
             #report_rind << losses[:tr_losses_p]
             #report_rind << losses[:consumteh]        
          end # indicii null
          if @eddate_b == @ddate_b then report_rind << nil end
          @report[nr-1] = report_rind[0..report_rind.count]  
         end  #test for fake mpoint       
        end  # mpoints each
        if @report[nr].nil? then @report[nr] = ['∑',nil,nil,nil,nil] end
        if @fwasimple then @report[nr] << enrgsums[:wa] end
        if @fsub then @report[nr] << enrgsums[:wasub] end                    
        if @fned then @report[nr] << enrgsums[:undercount] end          
        if @fwa then @report[nr] << enrgsums[:wa_without_wasub_with_undercount] end
        if @fwr then @report[nr] << (unless enrgsums[:wr].nil? then enrgsums[:wr].round(1) end) end                    
      end  # mpoints.count
      @ddate_b += 1.month
      @ddate_e += 1.month 
      @ddate_mb += 1.month 
      @ddate_me += 1.month
    end #while
    if @report.count != 0 then @report.last << 4 end
    titleforreports
    #render inline: "<%= @nc.inspect %><br><br><%= @emonth_for_report.inspect %><br><br><%= @ddate_b.inspect %><br><br><%= @ddate_e.inspect %><br><br>" and return   
  end #holub cauta
 
  def report  #kotik
    @page = params[:page]
    @id = params[:cp_id]
    @cp = Company.find(@id)
    if @fpr < 6 then  @flr = Filial.find(params[:flr_id]) else @flr = Furnizor.find(params[:flr_id]) end
    # month
    monthforreports
    # title
    @lista_title = []
    @lista_title << "LISTA de calcul a intrarii energiei electrice la #{@cp.name}"
    @lista_title << "pentru luna #{@luna} anul #{@ddate.year}"        
    # filter
    dataforfilterselect
    cookiesforreports
    @mpoints = mpointsforreports                             
    # report init    
    # report init
    @report = Array[]
    nr = 0
    cp_enrgsums = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    trlosses = 0.0 
    lnlosses = lnmelosses = 0.0
    consumteh = 0.0 
    # mpoints 
    if @mpoints.count == 0 then
      flash[:warning] = "Нет данных для отчета. Потребитель #{@cp.name} не имеет точек учета." 
    else
      @mpoints.each do |mp|
       if mp.cod != 0 then #test for fake mpoint 
        nr += 1  
        report_rind = [nr, "#{mp.cod} #{mp.name} #{mp.mesubstation.name}", if mp.meconname.count("a-zA-Zа-яА-ЯîÎ") > 0 then mp.meconname else"#{mp.voltcl} Î #{mp.meconname} F" end, "#{mp.clconname}", nil, nil, nil, nil, nil, nil, nil, nil] 
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
          @report << [nil,'Energie a/pr subabonat',nil,nil,nil,nil,nil,nil,nil,energies[:wasub],nil]
          cp_enrgsums[4] += energies[:wasub]  
        end
        unless energies[:wa_without_wasub].nil? then 
          @report << [nil,'Energie a/pr fara subabonat',nil,nil,nil,nil,nil,nil,nil,energies[:wa_without_wasub],nil]
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
        #unless losses[:ln_losses_ng].nil? then @report << [nil,'Потери ВЛ нагрузочные',nil,nil,nil,nil,nil,nil,nil,losses[:ln_losses_ng],nil] end 
        #unless losses[:ln_losses_kr].nil? then @report << [nil,'Потери ВЛ на корону',nil,nil,nil,nil,nil,nil,nil,losses[:ln_losses_kr],nil] end
        unless losses[:ln_losses].nil? then 
          @report << [nil,'Потери ВЛ (потребитель)',nil,nil,nil,nil,nil,nil,nil,losses[:ln_losses],2]
          lnlosses += losses[:ln_losses] 
        end
        unless losses[:ln_me_losses].nil? then 
          @report << [nil,'Потери ВЛ (МЭ)',nil,nil,nil,nil,nil,nil,nil,losses[:ln_me_losses],2]
          lnmelosses += losses[:ln_me_losses] 
        end        
        unless losses[:cosf].nil? then @report << [nil,'cos φ с потерями',nil,nil,nil,nil,nil,nil,nil,losses[:cosf],nil] end       
        unless losses[:consumteh].nil? then 
          @report << [nil,'Технологический расход',nil,nil,nil,nil,nil,nil,nil,losses[:consumteh],2]
          consumteh += losses[:consumteh] 
        end 
       end  #test for fake mpoint      
      end  # mpoint.each
    @report << ['∑','Итого Energie a/pr',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[0],4]
    @report << ['∑','Итого Energie a/pr subabonent',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[4],4]
    @report << ['∑','Итого Energie a/pr fara subabonent',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[5],4]       
    @report << ['∑','Итого Energie a/liv',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[1],4]
    @report << ['∑','Итого Energie r/pr',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[2],4]       
    @report << ['∑','Итого Energie r/liv',nil,nil,nil,nil,nil,nil,nil,cp_enrgsums[3],4]            
    @report << ['∑','Итого Потери в трансформаторах',nil,nil,nil,nil,nil,nil,nil,trlosses,3]
    @report << ['∑','Итого Потери ВЛ (потребитель)',nil,nil,nil,nil,nil,nil,nil,lnlosses,3]
    @report << ['∑','Итого Потери ВЛ (МЭ)',nil,nil,nil,nil,nil,nil,nil,lnmelosses,3]    
    @report << ['∑','Итого Потери в трансформаторах и ВЛ(потр)',nil,nil,nil,nil,nil,nil,nil,trlosses+lnlosses,3]  
    @report << ['∑','Итого Consum tehnologic',nil,nil,nil,nil,nil,nil,nil,consumteh,nil]          
    end  # if mpoint.count
    respond_to do |format|
      format.html
      format.pdf { send_data ListaReport.new.to_pdf(@cp,@report,@luna,@ddate,@luna_b,@luna_e), :type => 'application/pdf', :filename => "lista.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="lista.xlsx"' }
    end      
  end #kotik
  
private

  def roundconfpret(x, pret = 0)
    pret = pret.nil? ? 0 : pret 
    x = x.nil? ? 0 : x.round(pret)
    begin
      if pret == 0 then
        x = x.to_i 
      else
        x = x.to_i if x == x.to_i
      end
    rescue
    end  
    x
  end   

  def monthforreports   
    # month 
    @month_for_report = params[:month_for_report]
    @emonth_for_report = params[:emonth_for_report]   
    if @month_for_report.nil? then 
      @ddate = Date.current - (if action_name != 'graphreports' then 1.month else 3.month end)
      @month_for_report = (@ddate).to_formatted_s(:year_month) 
    else 
      @ddate = Date.strptime(@month_for_report, '%Y-%m') 
    end 
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
    if (@emonth_for_report.nil? or @emonth_for_report<@month_for_report) then 
      @eddate_b = @ddate_b + 2.month
      @emonth_for_report = @eddate_b.to_formatted_s(:year_month) 
    else 
      @eddate_b = (Date.strptime(@emonth_for_report,'%Y-%m')) 
    end 
  end
  
  def titleforreports  
    i = 1
    @title2 = []
    @title1.each do |t|
      if t == '' then
        @title2 << nil
      else 
        @title2 << i
        i += 1
      end  
    end
  end
  
  def cookiesforreports
    # filter
    @data_for_search = cookies[:data_for_search]
    @qmesubstation = cookies[:qmesubstation]
    @qcompany = cookies[:qcompany]
    @qregion = cookies[:qregion]
    @qfilial = cookies[:qfilial]
    @qfurnizor = cookies[:qfurnizor] 
  end 
  
  def mpointsforreports
    if (@data_for_search.nil? or @data_for_search.empty?) then
      if (@qmesubstation.nil? or @qmesubstation.empty?) and (@qcompany.nil? or @qcompany.empty?) and (@qregion.nil? or @qregion.empty?) and (@qfilial.nil? or @qfilial.empty?) and (@qfurnizor.nil? or @qfurnizor.empty?) then
        @filter = 0
        case when action_name == 'report' then
          mpoints = @flr.vmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + " and company_id = ? ", @flr.id, @cp.id).order(:region_name, :mesubstation_name, :company_shname, :id)
         when (action_name == 'reports' or action_name == 'simplereports') then
          mpoints = @flr.vmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(:company_shname, :region_name, :mesubstation_name, :cod, :id)
          #render inline: "<%= mpoints.inspect %><br><br>" and return         
         else
          mpoints = @flr.vmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(:region_name, :mesubstation_name, :company_shname, :id)  
        end 
      else     
        @filter = 1
        case when action_name == 'report' then                
          mpoints = @flr.vmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                                 "and (?='' or mesubstation_name=?) and (?='' or region_name=?) and (?='' or company_shname=?) and (?='' or filial_name=?)" +
                                 " and (?='' or furnizor_name=?)" + " and company_id = ? ", 
                                 @flr.id, @qmesubstation, @qmesubstation, @qregion, @qregion, @qcompany, @qcompany, @qfilial, @qfilial, @qfurnizor, @qfurnizor, @cp.id).order(:region_name, :mesubstation_name, :company_shname, :id)
         when (action_name == 'reports' or action_name == 'simplereports') then
          mpoints = @flr.vmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                                 "and (?='' or mesubstation_name=?) and (?='' or region_name=?) and (?='' or company_shname=?) and (?='' or filial_name=?)" +
                                 " and (?='' or furnizor_name=?)", 
                                 @flr.id, @qmesubstation, @qmesubstation, @qregion, @qregion, @qcompany, @qcompany, @qfilial, @qfilial, @qfurnizor, @qfurnizor).order(:company_shname, :region_name, :mesubstation_name, :cod, :id)
         else
          mpoints = @flr.vmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                                 "and (?='' or mesubstation_name=?) and (?='' or region_name=?) and (?='' or company_shname=?) and (?='' or filial_name=?)" +
                                 " and (?='' or furnizor_name=?)", 
                                 @flr.id, @qmesubstation, @qmesubstation, @qregion, @qregion, @qcompany, @qcompany, @qfilial, @qfilial, @qfurnizor, @qfurnizor).order(:region_name, :mesubstation_name, :company_shname, :id)          
        end                         
      end
    else
       @filter = 1
       @data_for_search = @data_for_search.upcase
       data_for_search = "%" + @data_for_search + "%"
       case when action_name == 'report' then      
         mpoints = @flr.vmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                                 "and (upper(company_name||company_shname) like upper(?) "+ 
                                 "or upper(cod||name) like upper(?) "+ 
                                 "or upper(filial_name||region_name||furnizor_name) like upper(?) "+ 
                                 "or upper(mesubstation_name) like upper(?)) " + " and company_id = ? ", 
                                 @flr.id, data_for_search, data_for_search, data_for_search, data_for_search, @cp.id).order(:region_name, :mesubstation_name, :company_shname, :id)
        when (action_name == 'reports' or action_name == 'simplereports') then
         mpoints = @flr.vmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                                 "and (upper(company_name||company_shname) like upper(?) "+ 
                                 "or upper(cod||name) like upper(?) "+ 
                                 "or upper(filial_name||region_name||furnizor_name) like upper(?) "+ 
                                 "or upper(mesubstation_name) like upper(?))", 
                                 @flr.id, data_for_search, data_for_search, data_for_search, data_for_search).order(:company_shname, :region_name, :mesubstation_name, :cod, :id)
        else
          mpoints = @flr.vmpoints.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end + 
                                 "and (upper(company_name||company_shname) like upper(?) "+ 
                                 "or upper(cod||name) like upper(?) "+ 
                                 "or upper(filial_name||region_name||furnizor_name) like upper(?) "+ 
                                 "or upper(mesubstation_name) like upper(?))", 
                                 @flr.id, data_for_search, data_for_search, data_for_search, data_for_search).order(:region_name, :mesubstation_name, :company_shname, :id)       
       end                                       
    end
    mpoints 
  end    

  def one_mp_indicii(mp_id, ddate_b, ddate_e, ddate_mb, ddate_me)
    result = {}
    mpoint = Mpoint.find(mp_id)
    wa = waliv = wri = wrc = 0.0
    wasub = waundercount = losundercount = nil
    indicii = []       
    mvnum = 0
    # billing days
    dddate_b = ddate_b
    mproperty = Mproperty.where("mpoint_id = ? and propdate <= ? and f = true", mpoint.id, dddate_b).order(propdate: :asc, created_at: :asc).last
    if mproperty.nil? then
      mproperty = Mproperty.new
      mproperty.mpoint_id = mpoint.id
      mproperty.voltcl = mpoint.voltcl
    end
    @temp = mproperty
    dddate_e = ddate_e
    mvalues = Vmpointsmetersvalue.where("id = ? AND (actdate between ? AND  ?) AND r = 'true'", mpoint.id, ddate_b, ddate_mb).order(:actdate).first
    unless mvalues.nil? then dddate_b = mvalues.actdate end
    mvalues = Vmpointsmetersvalue.where("id = ? AND (actdate between ? AND  ?) AND r = 'true'", mpoint.id, ddate_me, ddate_e).order(:actdate).first
    unless mvalues.nil? then dddate_e = mvalues.actdate end
    daysinperiod = ((dddate_e.to_date - dddate_b.to_date)).to_i   #number of days between report dates
    #---manual-input---
    minput = Minput.where("mpoint_id = ? AND mdate > ? AND mdate <= ? AND f = 'true'", mpoint.id, dddate_b, dddate_e).order(:mdate).last
    if minput then
      result[:minput_tplosses] = minput.tplosses
      result[:minput_trlosses] = minput.trlosses
      result[:minput_llosses] = minput.llosses
      result[:minput_cti] = minput.cti
      result[:minput_ctc] = minput.ctc
    end
    #meters
    meters = Vmpointsmeter.where("id = ? AND (? <  relevance_end) AND (? > relevance_date)", mp_id, dddate_b, dddate_e).order(:meter_id)
    if meters.count != 0 then      
       # indicii      
       dtsum  = 0
       trabsum = nil
       result[:wa_formula] = ""
       result[:waliv_formula] = ""
       result[:wri_formula] = ""
       result[:wrc_formula] = ""
       meters.each do |mitem|
        if mitem.meternum != 0 then      #is it fake meter?
         #---number-of-digits------------------------------- 
         indlimit = mitem.beforedigs.nil?  ? nil : (10**mitem.beforedigs)
         #--------------------------------------------------                                          
         koef = mitem.koefcalc           #koef 
         indicii0 = {:meternum => mitem.meternum, :koef => koef}
         mvalues = Vmpointsmetersvalue.where("id = ? AND meter_id = ? AND (actdate between ? AND  ?)", mpoint.id, mitem.meter_id, dddate_b, dddate_e).order(:actdate)
         if mvalues.count != 0 then
              if mvalues.count != 1 then  mvnum = 2 end  
              mvalue0 = mvalues.first
              mvalue1 = mvalues.last               
              date1 = mvalue1.actdate.to_date         #date1           
              date0 = mvalue0.actdate.to_date         #date0
              tmproperty = Mproperty.where("mpoint_id = ? and propdate <= ? and f = true", mpoint.id, date0).order(propdate: :asc, created_at: :asc).last
              if tmproperty.nil? then tmproperty = mproperty end              
              dt = ((date1 - date0)/1).to_i       #dt
              trab = mvalue1.trab             #trab from act
              dwa  = mvalue1.dwa              #dwa  from act
              undercount  = mvalue1.undercount  #undercount  from act
              indicii0 = {:meternum => mitem.meternum, :koef => koef, :date0 => date0, :date1 => date1, :dt => dt, :fnefact => mvalue1.fnefact} 
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
              if dind < 0 and mvalue1.fnozero.nil? then 
                dind = indicii0[:dind_180] = (dind + case when !indlimit.nil? then indlimit when ind0>=10000 then 100000 when ind0<1000 then 1000 else 10000 end).round(4) 
              end   #dind   180  
              energy = indicii0[:enrg_180] = (dind * koef).round(4) #energy 180
              unless tmproperty.fturn then
                indicii0[:ind1_activ] = mvalue1.actp180          #indicii activ
                indicii0[:ind0_activ] = mvalue0.actp180          #indicii activ
                indicii0[:wa] = energy                           #wa                 
                if result[:wa_formula] != "" then result[:wa_formula] += " + "  end  
                result[:wa_formula] += dind.to_s + " * " + koef.to_s
                wa += energy
              else
                if result[:waliv_formula] != "" then result[:waliv_formula] += " + "  end
                result[:waliv_formula] += dind.to_s + " * " + koef.to_s 
                indicii0[:waliv] = energy                        #waliv               
                if mvalue1.fanulare then 
                  waliv += energy
                  indicii0[:fanulare] = mvalue1.fanulare
                end
              end  
              unless dwa.nil? then 
                if wasub.nil? then wasub = dwa else wasub += dwa end
                indicii0[:dwa] = dwa 
              end
              unless undercount.nil? then 
                if waundercount.nil? then waundercount = undercount else waundercount += undercount end
                indicii0[:undercount] = undercount
                if mvalue1.fnefact then
                  indicii0[:losundercount] = undercount
                  if losundercount.nil? then losundercount = undercount else losundercount += undercount end
                end 
              end
              indicii0[:ind1_280] = mvalue1.actp280          #280
              ind1 = if mvalue1.actp280.nil? then 0 else mvalue1.actp280 end
              indicii0[:ind0_280] = mvalue0.actp280          #280
              ind0 = if mvalue0.actp280.nil? then 0 else mvalue0.actp280 end                
              dind = indicii0[:dind_280] = (ind1 - ind0).round(4)   #dind 280
              if dind < 0 and mvalue1.fnozero.nil? then 
                dind = indicii0[:dind_280] = (dind + case when !indlimit.nil? then indlimit when ind0>=10000 then 100000 when ind0<1000 then 1000 else 10000 end).round(4) 
              end   #dind   280  
              energy = indicii0[:enrg_280] = (dind * koef).round(4) #energy 280
              unless tmproperty.fturn then 
                if result[:waliv_formula] != "" then result[:waliv_formula] += " + "  end
                result[:waliv_formula] += dind.to_s + " * " + koef.to_s 
                indicii0[:waliv] = energy                        #waliv                
                if mvalue1.fanulare then 
                  waliv += energy
                  indicii0[:fanulare] = mvalue1.fanulare
                end
              else
                indicii0[:ind1_activ] = mvalue1.actp280          #indicii activ
                indicii0[:ind0_activ] = mvalue0.actp280          #indicii activ 
                indicii0[:wa] = energy                           #wa                  
                if result[:wa_formula] != "" then result[:wa_formula] += " + "  end
                result[:wa_formula] += dind.to_s + " * " + koef.to_s
                wa += energy                
              end  
              indicii0[:ind1_380] = mvalue1.actp380          #380 
              ind1 = if mvalue1.actp380.nil? then 0 else mvalue1.actp380 end
              indicii0[:ind0_380] = mvalue0.actp380          #380
              ind0 = if mvalue0.actp380.nil? then 0 else mvalue0.actp380 end
              dind = indicii0[:dind_380] = (ind1 - ind0).round(4)   #dind 380
              if dind < 0 and mvalue1.fnozero.nil? then 
                dind = indicii0[:dind_380] = (dind + case when !indlimit.nil? then indlimit when ind0>=10000 then 100000 when ind0<1000 then 1000 else 10000 end).round(4) 
              end   #dind   380           
              energy = indicii0[:enrg_380] = (dind * koef).round(4) #energy 380
              unless tmproperty.fturn then
                indicii0[:ind1_reactivl] = mvalue1.actp380          #indicii reactivL
                indicii0[:ind0_reactivl] = mvalue0.actp380          #indicii reactivL
                indicii0[:wri] = energy                             #wri                 
                if result[:wri_formula] != "" then result[:wri_formula] += " + "  end   
                result[:wri_formula] += dind.to_s + " * " + koef.to_s
                wri += energy
              else
                indicii0[:ind1_reactivc] = mvalue1.actp380          #indicii reactivC
                indicii0[:ind0_reactivc] = mvalue0.actp380          #indicii reactivC
                indicii0[:wrc] = energy                             #wrc                   
                if result[:wrc_formula] != "" then result[:wrc_formula] += " + "  end                 
                result[:wrc_formula] += dind.to_s + " * " + koef.to_s              
                wrc += energy                
              end  
              indicii0[:ind1_480] = mvalue1.actp480          #480
              ind1 = if mvalue1.actp480.nil? then 0 else mvalue1.actp480 end
              indicii0[:ind0_480] = mvalue0.actp480          #480
              ind0 = if mvalue0.actp480.nil? then 0 else mvalue0.actp480 end
              dind = indicii0[:dind_480] = (ind1 - ind0).round(4)   #dind 480
              if dind < 0 and mvalue1.fnozero.nil? then 
                dind = indicii0[:dind_480] = (dind + case when !indlimit.nil? then indlimit when ind0>=10000 then 100000 when ind0<1000 then 1000 else 10000 end).round(4) 
              end   #dind   480           
              energy = indicii0[:enrg_480] = (dind * koef).round(4) #energy 480              
              unless tmproperty.fturn then
                indicii0[:ind1_reactivc] = mvalue1.actp480          #indicii reactivC
                indicii0[:ind0_reactivc] = mvalue0.actp480          #indicii reactivC
                indicii0[:wrc] = energy                             #wrc                   
                if result[:wrc_formula] != "" then result[:wrc_formula] += " + "  end                 
                result[:wrc_formula] += dind.to_s + " * " + koef.to_s              
                wrc += energy
              else
                indicii0[:ind1_reactivl] = mvalue1.actp480          #indicii reactivL
                indicii0[:ind0_reactivl] = mvalue0.actp480          #indicii reactivL
                indicii0[:wri] = energy                             #wri                    
                if result[:wri_formula] != "" then result[:wri_formula] += " + "  end   
                result[:wri_formula] += dind.to_s + " * " + koef.to_s
                wri += energy                
              end            
         end # if mvalues.count
         indicii  << indicii0 
        end # is it fake meter?     
       end  # meters.each
       result[:indicii] = indicii
       result[:dddate_b] = dddate_b
       result[:dddate_e] = dddate_e
       result[:daysinperiod] = daysinperiod
       result[:mvnum] = mvnum
       if mvnum == 2 then
         # work hours
         if trabsum.nil? then
          #setsu said that trasformator and line work all the period, not only when the meter is on 
          #result[:workt] = dtsum * 24          
          #result[:workt_formula] = dtsum.to_s + " * 24  = "
          result[:workt] = (daysinperiod * 24)         
          result[:workt_formula] = daysinperiod.to_s + " * 24  = "          
         else
          result[:trab] = trabsum 
          #setsu said that trasformator and line work all the period, not only when the meter is on
          #result[:workt] = dtsum * 24 + trabsum
          #result[:workt_formula] = dtsum.to_s + " * 24 + " + trabsum.to_s + " = "
          result[:workt] = trabsum
          result[:workt_formula] = trabsum.to_s + " = "
         end           
         # energies
         result[:wa] = wa
         unless wasub.nil? then result[:wasub] = wasub end
         unless waundercount.nil? then result[:undercount] = waundercount end
         unless losundercount.nil? then result[:losundercount] = losundercount end  
         if !wasub.nil? then      
           result[:wa_without_wasub] = if wa > wasub then (wa - wasub) else 0.0 end 
           result[:wa_without_wasub_formula] = wa.to_s +  " - " + wasub.to_s 
         else
           result[:wa_without_wasub] = wa 
           result[:wa_without_wasub_formula] = wa.to_s           
         end
         if !waundercount.nil? then     
           result[:wa_without_wasub_with_undercount] = result[:wa_without_wasub] + waundercount
           result[:wa_without_wasub_with_undercount_formula] = "#{result[:wa_without_wasub]} + #{waundercount} "
         else
           result[:wa_without_wasub_with_undercount] = result[:wa_without_wasub]
           result[:wa_without_wasub_with_undercount_formula] = "#{result[:wa_without_wasub]} "           
         end
         if !losundercount.nil? then     
           result[:wa_without_wasub_with_losundercount] = result[:wa_without_wasub] + losundercount
           result[:wa_without_wasub_with_losundercount_formula] = "#{result[:wa_without_wasub]} + #{losundercount} "
         else
           result[:wa_without_wasub_with_losundercount] = result[:wa_without_wasub]
           result[:wa_without_wasub_with_losundercount_formula] = "#{result[:wa_without_wasub]} "           
         end  
        # result[:wa_formula] += " = "
         result[:waliv] = waliv
        # result[:waliv_formula] += " = "
         result[:wri] = wri
        # result[:wri_formula] += " = "
         result[:wrc] = wrc
        # result[:wrc_formula] += " = "
         result[:wr] = wri + wrc
         result[:wr_formula] = " #{wri} + #{wrc} "
         # косинус фи контрактный
         result[:cosfi_contract] = cosfi_contract = mproperty.cosfi
         if !cosfi_contract.nil? and cosfi_contract != 0 then
           result[:tgfi_contract] = tgfi_contract = ((1 / (cosfi_contract ** 2) - 1 ) ** 0.5).round(8) # tg fi
           result[:tgfi_contract_formula] = "(1 / (#{cosfi_contract} ^2) - 1 ) ^0.5 = " # tg fi
           result[:wr] = result[:wa_without_wasub] * tgfi_contract
           result[:wr_formula] = " #{result[:wa_without_wasub]} * #{tgfi_contract} "           
         end 
       end # if mvnum
     end # if meters.count 
     result
  end

  def add_one_mp_indicii(energies, result = {})  
    mvnum = energies[:mvnum]
    if mvnum == 2 then
      unless energies[:wa].nil? then 
         if result[:wa].nil? then result[:wa] = 0.0 end           
         result[:wa] += energies[:wa]
      end
      unless energies[:wasub].nil? then 
         if result[:wasub].nil? then result[:wasub] = 0.0 end           
         result[:wasub] += energies[:wasub]
      end      
      unless energies[:wa_without_wasub_with_undercount].nil? then 
         if result[:wa_without_wasub_with_undercount].nil? then result[:wa_without_wasub_with_undercount] = 0.0 end           
         result[:wa_without_wasub_with_undercount] += energies[:wa_without_wasub_with_undercount]
      end
      unless energies[:wr].nil? then 
         if result[:wr].nil? then result[:wr] = 0.0 end           
         result[:wr] += energies[:wr]
      end
      unless energies[:undercount].nil? then 
         if result[:undercount].nil? then result[:undercount] = 0.0 end           
         result[:undercount] += energies[:undercount]
      end
      unless energies[:losundercount].nil? then 
         if result[:losundercount].nil? then result[:losundercount] = 0.0 end           
         result[:losundercount] += energies[:losundercount]
      end      
    end # if mvnum
    result
  end

  def add_one_mp_losses(losses, result = {})
    unless losses[:tr_losses_p].nil? then 
      if result[:tr_losses_p].nil? then result[:tr_losses_p] = 0.0 end           
      result[:tr_losses_p] += losses[:tr_losses_p]
    end
    unless losses[:ln_losses].nil? then 
      if result[:ln_losses].nil? then result[:ln_losses] = 0.0 end           
      result[:ln_losses] += losses[:ln_losses]
    end
    unless losses[:ln_me_losses].nil? then 
      if result[:ln_me_losses].nil? then result[:ln_me_losses] = 0.0 end           
      result[:ln_me_losses] += losses[:ln_me_losses]
    end
    unless losses[:consumteh].nil? then 
      if result[:consumteh].nil? then result[:consumteh] = 0.0 end           
      result[:consumteh] += losses[:consumteh]
    end
    result
  end

  def one_mp_losses(mp_id, indicii)
    result={}   
    mpoint = Mpoint.find(mp_id)
    mvnum = indicii[:mvnum]       
    if mvnum == 2 && (indicii[:wa_without_wasub_with_losundercount]!=0 || indicii[:waliv]!=0 || indicii[:wri]!=0 || indicii[:wrc]!=0) then
      wa    = indicii[:wa_without_wasub_with_losundercount] 
      waliv = indicii[:waliv] 
      wri   = indicii[:wri]
      wrc   = indicii[:wrc]  
      wr    = indicii[:wr]
      workt = indicii[:workt]
      dddate_b = indicii[:dddate_b]
      mproperty = Mproperty.where("mpoint_id = ? and propdate <= ? and f = true", mpoint.id, dddate_b).order(propdate: :asc, created_at: :asc).last
      if mproperty.nil? then
        mproperty = Mproperty.new
        mproperty.mpoint_id = mpoint.id
        mproperty.voltcl = mpoint.voltcl
      end      
      #render inline: "<%= params.inspect %><br><br><%= mporperty.inspect %><br><br>" and return  
      dddate_e = indicii[:dddate_e]
      daysinperiod = indicii[:daysinperiod]       
      # косинус фи 
      if wa != 0 || wri != 0 then 
        cosfi = ((wa ** 2 / (wa ** 2 + wri ** 2)) ** 0.5).round(4)  #cos fi
      else
        cosfi = 0
      end 
      result[:cosfi] = cosfi
      result[:cosfi_formula] = "(" + wa.to_s + "^2 / (" + wa.to_s + " ^2 + " + wri.to_s + " ^2 )) ^0.5 = "       
      # косинус фи контрактный
      unless indicii[:cosfi_contract].nil? then cosfi = result[:cosfi_contract] = indicii[:cosfi_contract] end  
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
          unless mproperty.four then
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
            unless mproperty.four then
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
          unless mproperty.four then
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
        tr_losses_p = result[:tr_losses_p] = result[:calculated_tr_losses_p] = tr_losses_pxx + tr_losses_pkz
        result[:tr_losses_p_formula] = tr_losses_pxx.to_s + " + " + tr_losses_pkz.to_s 
        tr_losses_r = result[:tr_losses_r] = result[:calculated_tr_losses_r] = tr_losses_rxx + tr_losses_rkz
        result[:tr_losses_r_formula] = tr_losses_rxx.to_s + " + " + tr_losses_rkz.to_s  
        result[:ttaus] = ttaus            
      end  # if tr.count
      if !indicii[:minput_tplosses].nil? or !indicii[:minput_tplosses].nil? then # if was manual input
        if !indicii[:minput_tplosses].nil? then tr_losses_p = result[:tr_losses_p] = indicii[:minput_tplosses] end
        if !indicii[:minput_trlosses].nil? then tr_losses_r = result[:tr_losses_r] = indicii[:minput_trlosses] end  
      end   # if was manual input  
      #========begin=линии=========================================================== 
      # start variables
      ln_losses = ln_losses_ng = ln_losses_kr = 0.0  
      # varifing if any lines exist
      flines = mpoint.vlnparams.where("(? < condate_end) AND (? > condate)", dddate_b, dddate_e).exists?
      if flines && workt then
        if mproperty.voltcl == 0 then
          flash[:warning] = "Невозможно рассчитать потери в линии для #{mpoint.name}, т.к. voltcl = 0 !" 
        else
          unom = mproperty.voltcl               
          result[:ln_losses_ng_formula] = Array.new 
          result[:otpaika_losses_formula] = []    
          # making of array of uniq dates whithin report period    
          condates = mpoint.vlnparams.select(:condate).distinct.where("(? < condate_end) AND (? > condate) AND (condate > ?)", dddate_b, dddate_e, dddate_b).pluck(:condate)
          condates += mpoint.vlnparams.select(:condate_end).distinct.where("(? < condate_end) AND (? > condate) AND (condate_end < ?)", dddate_b, dddate_e, dddate_e).pluck(:condate_end)
          condates << dddate_b
          condates.uniq!
          condates.sort!
          # analize each condate from the array
          i = 0
          c = condates.size
          sum_hoursbdates = 0          
          condates.each do |icondate|
            i += 1
            # taking start and end of the current subperiod
            tdddate_b = icondate
            if i < c then tdddate_e = condates[i] else tdddate_e = dddate_e end
            daysbdates =  (tdddate_e.to_date - tdddate_b.to_date).to_i   #number of days between dates
            hoursbdates = ((tdddate_e.to_datetime - tdddate_b.to_datetime) * 24).to_i   #number of full hours between dates
            if i == c then
              hoursbdates = workt - sum_hoursbdates
            end
            sum_hoursbdates += hoursbdates    
          #  if hoursbdates > workt then hoursbdates = workt end
            if hoursbdates != workt then
              k_proportion_formula = "#{hoursbdates}/#{workt}"
              k_proportion = hoursbdates.to_f/workt
            else
              k_proportion_formula = k_proportion = nil                
            end            
            # lines at the start of the current subperiod    
            otpaiki = mpoint.vlnparams.where(" mesubstation2_id is not null AND (? < condate_end) AND (? >= condate) ", tdddate_b, tdddate_b)
            neotpaiki = mpoint.vlnparams.where(" mesubstation2_id is null AND (? < condate_end) AND (? >= condate) ", tdddate_b, tdddate_b).order(:id) 
            mpoint1 = mpoint.id
            if (otpaiki.exists? and !neotpaiki.exists?) then
              otpaiki.each do |otpaikaitem|
                mpoints_list = Vmpointslnparam.where("(? = line_id) AND (? < condate_end) AND (? >= condate)", otpaikaitem.line_id, tdddate_b, tdddate_b).order(:id)
                mpoints_list.each do |mpitem|
                  neotpaika = Vmpointslnparam.where("id = ? and mesubstation2_id is null AND (? < condate_end) AND (? >= condate)", mpitem.id, tdddate_b, tdddate_b).order(:id).first
                  if neotpaika then 
                    otpaiki = Vlnparam.where("mpoint_id=? AND mesubstation2_id is not null AND (? < condate_end) AND (? >= condate) ", mpitem.id, tdddate_b, tdddate_b)
                    neotpaiki = Vlnparam.where("mpoint_id=? AND mesubstation2_id is null AND (? < condate_end) AND (? >= condate) ", mpitem.id, tdddate_b, tdddate_b).order(:id)               
                    break 
                  end                
                end
              end
            end
            #==== begin otpaiki part 1
            otpaiki_losses = kwawr = nil
            otpaiki_losses_formula = otpaiki_wa_formula = otpaiki_wr_formula = ''
            if otpaiki.exists? then
              otpaiki_losses = otpaiki_wa = otpaiki_wr = 0
              otpaiki.each do |otpaikaitem|
                r = walk_around_line(otpaikaitem, 'otpaika', tdddate_b, hoursbdates, k_proportion, k_proportion_formula, unom, otpaiki_losses, otpaiki_wa, otpaiki_wr, otpaiki_wa_formula, otpaiki_wr_formula,mpoint.id,kwawr)
                otpaiki_losses += r[:losses]
                if otpaiki_losses_formula == '' then otpaiki_losses_formula = r[:losses_formula] else otpaiki_losses_formula += ' + ' + r[:losses_formula] end
                otpaiki_wa += r[:wa]
                otpaiki_wr += r[:wr]
                if otpaiki_wa_formula == '' then otpaiki_wa_formula = r[:wa_formula] else otpaiki_wa_formula += ' + ' + r[:wa_formula] end
                if otpaiki_wr_formula == '' then otpaiki_wr_formula = r[:wr_formula] else otpaiki_wr_formula += ' + ' + r[:wr_formula] end
                kwawr = r[:kwawr]
              end   # otpaiki.each
              #if result[:otpaika_losses_formula] then result[:otpaika_losses_formula] += " +\n\n " + otpaiki_losses_formula else result[:otpaika_losses_formula] = otpaiki_losses_formula end
              result[:otpaika_losses_formula] << [tdddate_b, tdddate_e, otpaiki_losses_formula, hoursbdates]
              if result[:otpaika_losses] then result[:otpaika_losses] += otpaiki_losses else result[:otpaika_losses] = otpaiki_losses end
            end # if otpaiki            
            # end otpaiki part 1         
            #==== begin neotpaiki part 1
            if neotpaiki then                                      
            losses = 0
            losses_formula = nil
              neotpaiki.each do |neotpaikaitem|
               # neotpaikaitem = neotpaiki 
                r = walk_around_line(neotpaikaitem, 'neotpaika', tdddate_b, hoursbdates, k_proportion, k_proportion_formula, unom, otpaiki_losses, otpaiki_wa, otpaiki_wr, otpaiki_wa_formula, otpaiki_wr_formula,mpoint.id,kwawr)
                losses += r[:losses]
                if losses_formula then losses_formula += ' + ' + r[:losses_formula] else losses_formula = r[:losses_formula] end
              end   # neotpaiki.each
              ln_losses_ng += losses
              result[:ln_losses_ng_formula] << [tdddate_b, tdddate_e, losses_formula, hoursbdates]
            end  # if neotpaiki.exists?
            # end neotpaiki part 1                    
          end # condates.each
          result[:ln_losses_ng] = ln_losses_ng     
          result[:ln_losses_kr] = ln_losses_kr
          if mproperty.fminuslinelosses then
            ln_losses = result[:ln_losses] = result[:calculated_ln_losses] = 0.0
            result[:ln_losses_formula] = "0.0"            
            result[:ln_me_losses] = ln_losses_ng + ln_losses_kr          
          else
            ln_losses = result[:ln_losses] = result[:calculated_ln_losses] = ln_losses_ng + ln_losses_kr
            result[:ln_losses_formula] = "#{ln_losses_ng} + #{ln_losses_kr}"
          end
        end # if voltcl != 0
      end
      unless indicii[:minput_llosses].nil? then ln_losses= result[:ln_losses] = indicii[:minput_llosses] end   # if was manual input       
      #========end=линии===========================================================                
      #============================================================================
      # cos fi with losses
      wal = result[:wal] = wa + waliv + tr_losses_p + ln_losses
      result[:wal_formula] = "#{wa} + #{waliv} + #{tr_losses_p} + #{ln_losses} ;            " + if wa >= 10000 then "#{wa} >= 10000 ► считать СТ" else "#{wa} < 10000 ► не считать СТ" end 
      if mproperty.voltcl > 10 then result[:wal_formula] += "; #{mproperty.voltcl} кВ > 10 кВ ► не считать СТ " end
      if mproperty.fct then result[:wal_formula] += "; установлен флаг ► не считать СТ " end
      wrl = result[:wrl] = wri + tr_losses_r
      result[:wrl_formula] = "#{wri} + #{tr_losses_r}"          
      if wa >= 10000 and not(mproperty.fct) and mproperty.voltcl <= 10 then
           if mproperty.fctc then result[:wal_formula] += "; установлен флаг ► не считать СТ(С) " end
           if mproperty.fctl then result[:wal_formula] += "; установлен флаг ► не считать СТ(L) " end
           if mproperty.fmargin then result[:wal_formula] += "; установлен флаг граница раздела " end
           wrcf = result[:wrcf] = wrc - tr_losses_r
           result[:wrcf_formula] = wrc.to_s + " - " + tr_losses_r.to_s           
           cosf = result[:cosf] = (wal / ((wal ** 2 + wrl ** 2) ** 0.5)).round(4)
           result[:cosf_formula] = wal.to_s + " / (( " + wal.to_s + "^2 + " + wrl.to_s + "^2) ^0.5)"
           if mproperty.voltcl == 0.4 then  
             tgficonst = 0.426
             cosficonst = 0.92 
           else 
             tgficonst = 0.567
             cosficonst = 0.87 
           end
           result[:tgficonst] = tgficonst
           result[:cosficonst] = cosficonst
           if cosf > cosficonst then result[:cosf_formula] += "; #{cosf} > #{cosficonst} ► не считать СТ(L) " end 
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
           if mproperty.fctc.nil? or mproperty.fctc == false then
             if mproperty.fmargin.nil? or mproperty.fmargin == false then                     
               result[:consumtehc] = result[:calculated_consumtehc] = ctc = ((wrc) * 0.1).round(4)
               result[:consumtehc_formula] = wrc.to_s + " * 0.1"
             else
               result[:consumtehc] = result[:calculated_consumtehc] = ctc = if wrcf > 0 then ((wrcf) * 0.1).round(4) else 0.0 end
               result[:consumtehc_formula] = if wrcf > 0 then "#{wrcf} * 0.1" else "0.0" end
             end    
           end
           if (mproperty.fctl.nil? or mproperty.fctl == false) and cosf <= cosficonst then 
             result[:consumtehi] = result[:calculated_consumtehi] = cti =((wrif ) * 0.1).round(4)
             result[:consumtehi_formula] = wrif.to_s + " * 0.1"              
           end
           ct = result[:consumteh] = result[:calculated_consumteh] = cti + ctc
           result[:consumteh_formula] = "#{cti} + #{ctc}"    
       end #if wa
      if !indicii[:minput_cti].nil? or !indicii[:minput_ctc].nil? then # if was manual input
        if !indicii[:minput_cti].nil? then result[:consumtehi] = cti = indicii[:minput_cti] else cti = 0 end
        if !indicii[:minput_ctc].nil? then result[:consumtehc] = ctc = indicii[:minput_ctc] else ctc = 0 end
        ct = result[:consumteh] = cti + ctc
        result[:consumteh_formula] = "#{cti} + #{ctc}"     
      end   # if was manual input                       
     end # if mvnum  
   result
   end
   
   def walk_around_line(lineitem, f, tdddate_b, hoursbdates, k_proportion, k_proportion_formula, unom, otpaiki_losses, otpaiki_wa, otpaiki_wr, otpaiki_wa_formula, otpaiki_wr_formula,mpoint1,kwawr)
    rez = {}
    wa = wr = 0
    wa_formula = wr_formula = ''
    if !lineitem.unom.nil? and lineitem.unom != 0 then unom = lineitem.unom end 
    mpoints_list = Vmpointslnparam.where("(? = line_id) AND (? < condate_end) AND (? >= condate)", lineitem.line_id, tdddate_b, tdddate_b)
    mpoints_list.each do |mpitem|
      fneotpaika = Vmpointslnparam.where("id = ? and mesubstation2_id is null AND (? < condate_end) AND (? >= condate)", mpitem.id, tdddate_b, tdddate_b).any?
      if (f == 'otpaika'  and !fneotpaika) or (f == 'neotpaika') then
        energies = one_mp_indicii(mpitem.id, @ddate_b, @ddate_e, @ddate_mb, @ddate_me)
        if energies[:mvnum] == 2 then 
           wa += energies[:wa_without_wasub_with_losundercount] 
           wa_formula += unless wa_formula == '' then " + " else '' end + "#{energies[:wa_without_wasub_with_losundercount]}" 
           wr += energies[:wr]
           wr_formula += unless wr_formula == '' then " + " else '' end + "#{energies[:wr]}" 
           if (mpitem.id == mpoint1) then
             kwawr = energies[:wa_without_wasub_with_losundercount] + energies[:wr]
           end  
        end   # if mvnum              
      end # if otpaika or neopaika                   
    end   # mpoints_list.each
    if (f == 'neotpaika' and !otpaiki_losses.nil?) then
       wa += otpaiki_wa
       if otpaiki_wa_formula != '' then 
         if wa_formula != '' then wa_formula += " + #{otpaiki_wa_formula}" else wa_formula = "#{otpaiki_wa_formula}" end
       end
       wr += otpaiki_wr 
       if otpaiki_wr_formula != '' then 
         if wr_formula != '' then wr_formula += " + #{otpaiki_wr_formula}" else wr_formula = "#{otpaiki_wr_formula}" end
       end         
    end    
    kkwawr = wa + wr
    rez[:kwawr] = kwawr
    rez[:wa] = wa
    rez[:wa_formula] = wa_formula
    rez[:wr] = wr
    rez[:wr_formula] = wr_formula        
    if k_proportion and k_proportion != 1 then  
       wa = wa * k_proportion
       wr = wr * k_proportion
       wa_formula = "( " + wa_formula + " ) * #{k_proportion_formula}"
       wr_formula = "( " + wr_formula + " ) * #{k_proportion_formula}"
    end    
    if (f == 'neotpaika' and !otpaiki_losses.nil?) then
       wa += otpaiki_losses 
       wa_formula += " + #{otpaiki_losses}"        
    end
    if kwawr.to_f == 0 then
      kw = 0
    elsif !kwawr.to_f.nan? and !kkwawr.to_f.nan? and kkwawr then
      kw =  kwawr.to_f / kkwawr
    end
    losses_formula = "#{lineitem.r} * #{lineitem.k_f} ^2 * ( (#{wa_formula}) ^2 + (#{wr_formula}) ^2 ) / (1000 * #{unom} ^2 * #{hoursbdates}) "
    losses = ( lineitem.r * (lineitem.k_f ** 2) * (wa ** 2 + wr ** 2) / (1000 * ((unom) ** 2) * hoursbdates) )        
    if (f == 'neotpaika' and !kw.to_f.nan? and kw and kw != 1) then
       losses_formula += " * #{kw.round(4)}"
       losses *= kw  
    end 
    losses = losses.round(4)      
    rez[:losses_formula] = losses_formula
    rez[:losses] = losses   
    rez
   end 
   
   def dataforfilterselect
    @sstations = Mesubstation.where("f = ?", true).order(name: :asc).pluck(:name, :id)
    @comps = Company.where("f = ?", true).order(name: :asc).pluck(:name, :id)
    @furns = if (@flr.nil? || (@fpr < 6)) then Furnizor.all.pluck(:name, :id)  else [[@flr.name, @flr.id]] end
    @fils  = if (@flr.nil? || (@fpr >= 6)) then Filial.all.pluck(:name, :id)   else [[@flr.name, @flr.id]] end   
    @fcomps = Vallmpoint.select(:company_shname).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(company_shname: :asc).pluck(:company_shname)
    @fsstations = Vallmpoint.select(:mesubstation_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(mesubstation_name: :asc).pluck(:mesubstation_name)
    @ffurns = if (@flr.nil? || (@fpr < 6))  then Vallmpoint.select(:furnizor_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(furnizor_name: :asc).pluck(:furnizor_name) else [[@flr.name]] end
    @ffils  = if (@flr.nil? || (@fpr >= 6)) then Vallmpoint.select(:filial_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(filial_name: :asc).pluck(:filial_name)   else [[@flr.name]] end 
    @fregions = Vallmpoint.select(:region_name).distinct.where(if @fpr < 6 then "filial_id = ? " else "furnizor_id = ? " end, @flr.id).order(region_name: :asc).pluck(:region_name) 
   end
   
   def filtertocookies
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
   end
  
   def indexview
    filtertocookies
    @filter = 0      
    company_list = @flr.vallmpoints.pluck(:company_id).uniq
    if @data_for_search.nil? or @data_for_search.empty? then
      if (@qmesubstation.nil? or @qmesubstation.empty?) and (@qcompany.nil? or @qcompany.empty?) and (@qregion.nil? or @qregion.empty?) and (@qfilial.nil? or @qfilial.empty?) and (@qfurnizor.nil? or @qfurnizor.empty?) then   
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
  
  def indexviewall(f=0)
    #-----------------------------------------
    if params[:search] then
       cookies[:company_search] = @data_for_search = params[:company_search].to_s
    else
       @data_for_search = cookies[:company_search]
    end
    if @data_for_search.nil? or @data_for_search.empty? then
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
    unless (f) then 
      unless @companies.nil? then @companies = @companies.paginate(:page => @page, :per_page => $PerPage ) end     
    end              
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

  def company_params
    params.require(:company).permit(:id,:name,:shname,:cod,:comment,:f)
  end
      
  def company_init(company)
    t = company.name = mylrstreep(company_params[:name])
    t1 = mylrstreep(company_params[:shname])
    if t1.size == 0 then t1 = t[0,14] end      
    company.shname = t1  
    company.cod = mylrstreep(company_params[:cod]) 
    company.comment = mylrstreep(company_params[:comment])
    company.f = if company_params[:f].nil? then false else true end  
    company    
  end        
     
end
