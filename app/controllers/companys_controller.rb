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
    i=0
    report_rind = Array[]
    @report = Array[]
    if (params[:date_for_report]).nil? then @ddate = Date.current else @ddate = params[:date_for_report].to_date end
    @ddateb1 = Date.new(2000, 1, 1)  
    @ddateb2 = @ddate.change(day: 1)-1.month
    @ddatee1 = @ddate.change(day: 2)-1.month    
    @ddatee2 = @ddate.change(day: 1)
    @mp.each do |item|
      report_rind[0] = i+1     
      report_rind[1] = "#{item.messtation} (#{item.clsstation})"
      report_rind[2] = "#{item.meconname} (#{item.clconname})"
      report_rind[3] = item.meternum
      @mv0 = Mvalue.where("mpoint_id = ? AND (actp180 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", item.id, @ddateb1, @ddateb2)
      @mv1 = Mvalue.where("mpoint_id = ? AND (actp180 IS NOT NULL) AND (/*actdate >= ? AND*/ actdate <= ?)", item.id, @ddatee1, @ddatee2)
      if @mv0.count !=0 then report_rind[4] = @mv0.order(:actdate, :created_at, :updated_at).last.actp180 else report_rind[4] = nil end       
      if @mv1.count !=0 then report_rind[5] = @mv1.order(:actdate, :created_at, :updated_at).last.actp180 else report_rind[5] = nil end
      report_rind[6] = report_rind[4].to_f - report_rind[5].to_f  
      if item.koefcalc.nil? then report_rind[7] = 1 else report_rind[7] = item.koefcalc end           
      report_rind[8] = report_rind[7].to_i * report_rind[6].to_f  
      @report[i] =  [report_rind[0],report_rind[1],report_rind[2],report_rind[3],report_rind[4],report_rind[5],report_rind[6],report_rind[7],report_rind[8]]      
      i+=1
    end    
  end  
  
  def index
  end
  
end
