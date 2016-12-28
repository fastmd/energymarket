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
    @perpage = 10      
    @cp =  Company.find(params[:id])
    @mp =  @cp.mpoints.all.paginate(:page => params[:page], :per_page => @perpage )   
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
    @cp =  Company.find(params[:id])
    @mp =  @cp.mpoints.all   
  end  
  
  def setsushow
    @cp =  Company.find(params[:id])
    @mp =  @cp.mpoints.all
  end

  def index
    @companies = Company.all
  end
  
end
