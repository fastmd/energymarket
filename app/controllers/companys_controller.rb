class CompanysController < ApplicationController
  def new
  end
  
  def create
    
    @cp =  Company.new
    
    @cp.name = params[:coname]
    @cp.save
  
    redirect_to company_path(@cp)
  
  #redirect_to @cp
    
   #redirect_to mpoint_path(@cp)
  end

  def show
    if current_user.has_role? :"setsu-nord"
      @fpr = 1
    end 
    if current_user.has_role? :"setsu-nord-vest"
      @fpr = 2
    end
    if current_user.has_role? :"setsu-centru"
      @fpr = 3
    end
    if current_user.has_role? :"setsu-sud"
      @fpr = 4
    end
    if current_user.has_role? :"setsu"
      @fpr = 5
    end
    if current_user.has_role? :"cduser-fee"
      @fpr = 6
    end
    if current_user.has_role? :"cduser-fenosa"
      @fpr = 7
    end
    if current_user.has_role? :"cduser"
      @fpr = 8
    end
    
    
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
