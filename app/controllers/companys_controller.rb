class CompanysController < ApplicationController
  
  def new
  end
  
  def create    
    @cp =  Company.new
    @cp.furnizor_id = 1;
    @cp.filial_id = 1;
    @cp.name = params[:coname]
    @cp.save
    redirect_to company_path(@cp)
    #redirect_to @cp
    #redirect_to mpoint_path(@cp)
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
    if (params[:date_for_report]).nil? then @ddate = Date.current else @ddate = params[:date_for_report].to_date end
    luni = ['ianuarie','februarie','martie','aprilie','mai','iunie','iulie','august','septembrie','octombrie','noiembrie','decembrie']  
    @luna = luni[@ddate.month.to_i-1]                               
    @ddateb1 = Date.new(2000, 1, 1)  
    @ddateb2 = @ddate.change(day: 1)-1.month
    @ddatee1 = @ddate.change(day: 2)-1.month    
    @ddatee2 = @ddate.change(day: 1)
    i=0
    j=0
    suma = 0.0
    losses = 0.0    
    @mp.each do |item|
      j = j+1
      report_rind[0] = j    
      report_rind[1] = "#{item.messtation} (#{item.clsstation})"
      report_rind[2] = "#{item.meconname} (#{item.clconname})"
      @met = item.meters.first
      if !@met.nil? then
        report_rind[3] = @met.meternum
        if @met.koefcalc.nil? then report_rind[7] = 1.to_i else report_rind[7] = @met.koefcalc.to_i end         
        @mv1 = Mvalue.where("meter_id = ? AND (actp180 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddateb1, @ddateb2)
        @mv0 = Mvalue.where("meter_id = ? AND (actp180 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddatee1, @ddatee2)
        if @mv0.count !=0 then report_rind[4] = @mv0.order(:actdate, :created_at, :updated_at).last.actp180 else report_rind[4] = nil end       
        if @mv1.count !=0 then report_rind[5] = @mv1.order(:actdate, :created_at, :updated_at).last.actp180 else report_rind[5] = nil end
        report_rind[6] = (report_rind[4].to_f - report_rind[5].to_f).round 4            
        report_rind[8] = (report_rind[7] * report_rind[6]).round 4
        suma +=  report_rind[8] 
        @report[i] =  [report_rind[0],report_rind[1],report_rind[2]+' a/pr',report_rind[3],report_rind[4],report_rind[5],report_rind[6],report_rind[7],report_rind[8]]      
        i+=1
        @mv1 = Mvalue.where("meter_id = ? AND (actp280 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddateb1, @ddateb2)
        @mv0 = Mvalue.where("meter_id = ? AND (actp280 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddatee1, @ddatee2)
        if @mv0.count !=0 then report_rind[4] = @mv0.order(:actdate, :created_at, :updated_at).last.actp280 else report_rind[4] = nil end       
        if @mv1.count !=0 then report_rind[5] = @mv1.order(:actdate, :created_at, :updated_at).last.actp280 else report_rind[5] = nil end
        report_rind[6] = (report_rind[4].to_f - report_rind[5].to_f).round 4           
        report_rind[8] = (report_rind[7] * report_rind[6]).round 4   
        @report[i] =  [nil,nil,report_rind[2]+' a/liv',nil,report_rind[4],report_rind[5],report_rind[6],report_rind[7],report_rind[8]]      
        i+=1 
        @mv1 = Mvalue.where("meter_id = ? AND (actp380 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddateb1, @ddateb2)
        @mv0 = Mvalue.where("meter_id = ? AND (actp380 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddatee1, @ddatee2)
        if @mv0.count !=0 then report_rind[4] = @mv0.order(:actdate, :created_at, :updated_at).last.actp380 else report_rind[4] = nil end       
        if @mv1.count !=0 then report_rind[5] = @mv1.order(:actdate, :created_at, :updated_at).last.actp380 else report_rind[5] = nil end
        report_rind[6] = (report_rind[4].to_f - report_rind[5].to_f).round 4            
        report_rind[8] = (report_rind[7] * report_rind[6]).round 4   
        @report[i] =  [nil,nil,report_rind[2]+' r/pr',nil,report_rind[4],report_rind[5],report_rind[6],report_rind[7],report_rind[8]]      
        i+=1
        @mv1 = Mvalue.where("meter_id = ? AND (actp480 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddateb1, @ddateb2)
        @mv0 = Mvalue.where("meter_id = ? AND (actp480 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", @met.id, @ddatee1, @ddatee2)
        if @mv0.count !=0 then report_rind[4] = @mv0.order(:actdate, :created_at, :updated_at).last.actp480 else report_rind[4] = nil end       
        if @mv1.count !=0 then report_rind[5] = @mv1.order(:actdate, :created_at, :updated_at).last.actp480 else report_rind[5] = nil end
        report_rind[6] = (report_rind[4].to_f - report_rind[5].to_f).round 4            
        report_rind[8] = (report_rind[7] * report_rind[6]).round 4  
        @report[i] =  [nil,nil,report_rind[2]+' r/liv',nil,report_rind[4],report_rind[5],report_rind[6],report_rind[7],report_rind[8]]      
        i+=1  
      end  
    end
        @report[i] =  [nil,'Потери в линии',nil,nil,nil,nil,nil,nil,losses]      
        i+=1 
        @report[i] =  [nil,'Сумма',nil,nil,nil,nil,nil,nil,suma]       
        i+=1         
  end  
  
  def index
  end
  
end
