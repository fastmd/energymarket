class WelcomeController < ApplicationController
  def index
    if current_user.has_role? :cduser            then redirect_to welcome_cdindex_path end
    if current_user.has_role? :"cduser-fee"      then redirect_to welcome_cdindex_path end
    if current_user.has_role? :"cduser-fenosa"   then redirect_to welcome_cdindex_path end    
    if current_user.has_role? :setsu             then redirect_to welcome_setsuindex_path end
    if current_user.has_role? :"setsu-nord"      then redirect_to welcome_setsuindex_path end
    if current_user.has_role? :"setsu-nord-vest" then redirect_to welcome_setsuindex_path end
    if current_user.has_role? :"setsu-centru"    then redirect_to welcome_setsuindex_path end
    if current_user.has_role? :"setsu-sud"       then redirect_to welcome_setsuindex_path end   
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
      @furns = Furnizor.paginate(:page => params[:page], :per_page => @perpage = 10)
    end
    @companies = Company.all
  end
  
  def setsuindex 
    @furns = Furnizor.all
    @fl = Filial.paginate(:page => params[:page], :per_page => @perpage = 10)
    @companies = Company.all
    if current_user.has_role? :"setsu-nord"       then @fpr = 1 end 
    if current_user.has_role? :"setsu-nord-vest"  then @fpr = 2 end
    if current_user.has_role? :"setsu-centru"     then @fpr = 3 end
    if current_user.has_role? :"setsu-sud"        then @fpr = 4 end
    if current_user.has_role? :"setsu"            then @fpr = 5 end   
  end
    
end
