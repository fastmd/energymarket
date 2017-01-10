class CompanysController < ApplicationController
  
  def new
  end
  
  def create    
    @cp =  Company.new
    @cp.name = params[:name]
    @cp.region = params[:region]
    @cp.furnizor_id = params[:furnizor_id];
    @cp.filial_id = params[:filial_id];    
    @cp.save
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
    @cp =  Company.find(params[:id])
    @mp =  @cp.mpoints.all.paginate(:page => params[:page], :per_page => @perpage = 10 )   
  end
  
  def report
    if current_user.has_role? :"setsu-nord"      then  @fpr = 1 end 
    if current_user.has_role? :"setsu-nord-vest" then  @fpr = 2 end
    if current_user.has_role? :"setsu-centru"    then  @fpr = 3 end
    if current_user.has_role? :"setsu-sud"       then  @fpr = 4 end
    if current_user.has_role? :"setsu"           then  @fpr = 5 end
    if current_user.has_role? :"cduser"          then  @fpr = 6 end
    if current_user.has_role? :"cduser-fee"      then  @fpr = 7 end
    if current_user.has_role? :"cduser-fenosa"   then  @fpr = 8 end
    @cp = Company.find(params[:id])
    @id = params[:id]
    @mp = @cp.mpoints.all
    report_rind = Array[]
    @report = Array[]
    @month_for_report = (params[:month_for_report])
    if (params[:month_for_report]).nil? then @ddate = Date.current else @ddate = Date.strptime(params[:month_for_report], '%Y-%m') end
 #   if (params[:date_for_report]).nil? then @ddate = Date.current else @ddate = params[:date_for_report].to_date end
    luni = ['ianuarie','februarie','martie','aprilie','mai','iunie','iulie','august','septembrie','octombrie','noiembrie','decembrie']  
    @luna = luni[@ddate.month.to_i-1]                               
    @ddateb1 = Date.new(2000, 1, 1)  
    @ddateb2 = @ddate.change(day: 1)-1.month
    @ddatee1 = @ddate.change(day: 2)-1.month    
    @ddatee2 = @ddate.change(day: 1)
    i=0
    j=0
    sumaapr = 0.0
    sumaaliv = 0.0
    losses = 0.0    
    @mp.each do |item|
      j = j+1
      report_rind[0] = j    
      report_rind[1] = "#{item.messtation} (#{item.clsstation})"
      report_rind[2] = "#{item.meconname} (#{item.clconname})"
      report_rind[3] = "#{item.clconname}"
      @met = item.meters.first
      if !@met.nil? then
        report_rind[4] = @met.meternum
        if @met.koefcalc.nil? then report_rind[8] = 1.to_i else report_rind[8] = @met.koefcalc.to_i end         
        mv1 = Mvalue.where("meter_id = ? AND (actp180 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddateb1, @ddateb2)
        mv0 = Mvalue.where("meter_id = ? AND (actp180 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddatee1, @ddatee2)
        if mv0.count !=0 then report_rind[5] = mv0.order(:actdate, :created_at, :updated_at).last.actp180 else report_rind[5] = nil end       
        if mv1.count !=0 then report_rind[6] = mv1.order(:actdate, :created_at, :updated_at).last.actp180 else report_rind[6] = nil end
        report_rind[7] = (report_rind[5].to_f - report_rind[6].to_f).round 4            
        report_rind[9] = (report_rind[8] * report_rind[7]).round 4
        wapr = report_rind[9]
        sumaapr +=  report_rind[9] 
        @report[i] =  [report_rind[0],report_rind[1],report_rind[2]+' a/pr',report_rind[3],report_rind[4],report_rind[5],report_rind[6],report_rind[7],report_rind[8],report_rind[9]]      
        i+=1
        mv1 = Mvalue.where("meter_id = ? AND (actp280 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddateb1, @ddateb2)
        mv0 = Mvalue.where("meter_id = ? AND (actp280 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddatee1, @ddatee2)
        if mv0.count !=0 then report_rind[5] = mv0.order(:actdate, :created_at, :updated_at).last.actp280 else report_rind[5] = nil end       
        if mv1.count !=0 then report_rind[6] = mv1.order(:actdate, :created_at, :updated_at).last.actp280 else report_rind[6] = nil end
        report_rind[7] = (report_rind[5].to_f - report_rind[6].to_f).round 4           
        report_rind[9] = (report_rind[8] * report_rind[7]).round 4
        waliv = report_rind[9]
        sumaaliv +=  report_rind[9]    
        @report[i] =  [nil,nil,report_rind[2]+' a/liv',nil,nil,report_rind[5],report_rind[6],report_rind[7],report_rind[8],report_rind[9]]      
        i+=1 
        mv1 = Mvalue.where("meter_id = ? AND (actp380 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddateb1, @ddateb2)
        mv0 = Mvalue.where("meter_id = ? AND (actp380 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddatee1, @ddatee2)
        if mv0.count !=0 then report_rind[5] = mv0.order(:actdate, :created_at, :updated_at).last.actp380 else report_rind[5] = nil end       
        if mv1.count !=0 then report_rind[6] = mv1.order(:actdate, :created_at, :updated_at).last.actp380 else report_rind[6] = nil end
        report_rind[7] = (report_rind[5].to_f - report_rind[6].to_f).round 4            
        report_rind[9] = (report_rind[8] * report_rind[7]).round 4 
        wrpr = report_rind[9]  
        @report[i] =  [nil,nil,report_rind[2]+' r/pr',nil,nil,report_rind[5],report_rind[6],report_rind[7],report_rind[8],report_rind[9]]      
        i+=1
        mv1 = Mvalue.where("meter_id = ? AND (actp480 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddateb1, @ddateb2)
        mv0 = Mvalue.where("meter_id = ? AND (actp480 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddatee1, @ddatee2)
        if mv0.count !=0 then report_rind[5] = mv0.order(:actdate, :created_at, :updated_at).last.actp480 else report_rind[5] = nil end       
        if mv1.count !=0 then report_rind[6] = mv1.order(:actdate, :created_at, :updated_at).last.actp480 else report_rind[6] = nil end
        report_rind[7] = (report_rind[5].to_f - report_rind[6].to_f).round 4            
        report_rind[9] = (report_rind[8] * report_rind[7]).round 4 
        wrliv = report_rind[9] 
        @report[i] =  [nil,nil,report_rind[2]+' r/liv',nil,nil,report_rind[5],report_rind[6],report_rind[7],report_rind[8],report_rind[9]]      
        i+=1 
        cosfi = ((wapr ** 2 / (wapr ** 2 + wrpr ** 2))  ** 0.5).round 4 
        @report[i] =  [nil,'cos fi /pr',nil,nil,nil,nil,nil,nil,nil,cosfi]       
        i+=1  
        cosfi = ((waliv ** 2 / (waliv ** 2 + wrliv ** 2))  ** 0.5).round 4          
        @report[i] =  [nil,'cos fi /liv',nil,nil,nil,nil,nil,nil,nil,cosfi]       
        i+=1           
      end  
    end
        @report[i] =  [nil,'Потери в линии',nil,nil,nil,nil,nil,nil,nil,losses]      
        i+=1 
        @report[i] =  [nil,'Сумма a/pr',nil,nil,nil,nil,nil,nil,nil,sumaapr]       
        i+=1
        @report[i] =  [nil,'Сумма a/liv',nil,nil,nil,nil,nil,nil,nil,sumaaliv]       
        i+=1 
    respond_to do |format|
      format.html
      format.pdf { send_data ListaReport.new.to_pdf(@cp,@report,@luna,@ddate,@ddatee2,@ddateb2), :type => 'application/pdf', :filename => "lista.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="lista.xlsx"' }
    end                         
  end  
  
  def index
  end
  
end
