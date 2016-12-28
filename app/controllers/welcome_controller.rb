class WelcomeController < ApplicationController
  def index
    if current_user.has_role? :cduser
      redirect_to welcome_cdindex_path
    end
    if current_user.has_role? :"cduser-fee"
      redirect_to welcome_cdindex_path
    end
     if current_user.has_role? :"cduser-fenosa"
      redirect_to welcome_cdindex_path
    end    
    if current_user.has_role? :setsu
      redirect_to welcome_setsuindex_path
    end
    if current_user.has_role? :"setsu-nord"
      redirect_to welcome_setsuindex_path
    end
    if current_user.has_role? :"setsu-nord-vest"
      redirect_to welcome_setsuindex_path
    end
    if current_user.has_role? :"setsu-centru"
      redirect_to welcome_setsuindex_path
    end
    if current_user.has_role? :"setsu-sud"
      redirect_to welcome_setsuindex_path
    end   
   # @furns = Furnizor.all
   # @filials = Filial.all
   # @companies = Company.all         
  end
  
  def cdindex
    if current_user.has_role? :"cduser-fee"
      @fpr = 2
      @furn = Furnizor.find(@fpr)
    end 
    if current_user.has_role? :"cduser-fenosa"
      @fpr = 1
      @furn = Furnizor.find(@fpr)
    end
    if current_user.has_role? :"cduser"
      @fpr = 0
      @perpage = 10
      @furns = Furnizor.paginate(:page => params[:page], :per_page => @perpage = 10 )
    end
    @companies = Company.all
  end
  
  def setsuindex 
    @furns = Furnizor.all
    @fl = Filial.all
    @companies = Company.all
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
  end
    
end
