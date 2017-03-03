class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :check_user
  before_filter :nav_menu 
  $GreenDelay = 60*60
  $PerPage = 10
  $Luni = ['ianuarie','februarie','martie','aprilie','mai','iunie','iulie','august','septembrie','octombrie','noiembrie','decembrie']  
  
  def nav_menu
   if !current_user.nil? then 
    if (current_user.has_role? :cduser) or (current_user.has_role? :"cduser-fee") or (current_user.has_role? :"cduser-fenosa") then 
      @navheader = 'Поставщики'
      @pages = Furnizor.all.order(name: :asc)
      @subpages = Company.all.order(name: :asc)
      @leaves  = Mpoint.all
    end 
    if (current_user.has_role? :setsu) or (current_user.has_role? :"setsu-nord") or (current_user.has_role? :"setsu-nord-vest") or (current_user.has_role? :"setsu-centru")  or (current_user.has_role? :"setsu-sud")  then 
      @navheader = 'Филиалы'
      @pages = Filial.all.order(name: :asc)
      @subpages = Company.all.order(name: :asc)
      @leaves  = Mpoint.all
    end
      @count_mpoints={}
      if !@subpages.nil?
         @subpages.each do |subitem|
         i=0  
         if !@leaves.nil?
            @leaves.each do |leaf|
               if subitem.id==leaf.company_id then i+=1 end                           
            end              
         end 
         if i==0 then @count_mpoints[subitem.id] = nil else @count_mpoints[subitem.id] = i end                      
         end                
      end                   
   end 
  end
  
private       
      
  def check_user
    if !current_user.nil? then 
      if current_user.has_role? :"setsu-nord"      then  @fpr = 1 end 
      if current_user.has_role? :"setsu-nord-vest" then  @fpr = 2 end
      if current_user.has_role? :"setsu-centru"    then  @fpr = 3 end
      if current_user.has_role? :"setsu-sud"       then  @fpr = 4 end
      if current_user.has_role? :"setsu"           then  @fpr = 5 end
      if current_user.has_role? :"cduser"          then  @fpr = 6 end
      if current_user.has_role? :"cduser-fee"      then  @fpr = 7 end
      if current_user.has_role? :"cduser-fenosa"   then  @fpr = 8 end     
    end      
  end  
   
  end
