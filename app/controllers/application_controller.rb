class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :nav_menu 
  $GreenDelay = 60*60
  $PerPage = 10
  
  def nav_menu
   if !current_user.nil? then 
    if (current_user.has_role? :cduser) or (current_user.has_role? :"cduser-fee") or (current_user.has_role? :"cduser-fenosa") then 
      @navheader = 'Поставщики'
      @pages = Furnizor.all.order(name: :asc)
      @subpages = Company.all.order(name: :asc)
    end 
    if (current_user.has_role? :setsu) or (current_user.has_role? :"setsu-nord") or (current_user.has_role? :"setsu-nord-vest") or (current_user.has_role? :"setsu-centru")  or (current_user.has_role? :"setsu-sud")  then 
      @navheader = 'Филиалы'
      @pages = Filial.all.order(name: :asc)
      @subpages = Company.all.order(name: :asc)
    end
   end 
  end
   
  end
