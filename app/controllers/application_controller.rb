class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :check_user
  before_filter :nav_menu 
  $GreenDelay = 60*60
  $PerPage = 10
  $Luni = ['ianuarie','februarie','martie','aprilie','mai','iunie','iulie','august','septembrie','octombrie','noiembrie','decembrie'] 
  $data_for_search = ''
  $qmesubstation = ''
  $qcompany = ''
  $qregion = ''
  $qfilial = ''
  $qfurnizor = '' 
  
  def nav_menu
   if !current_user.nil? then 
    if (current_user.has_role? :cduser) then 
      @navheader = 'Поставщики'
      @pages = Furnizor.all.order(name: :asc)
      @subpages = Vallmpoint.select(:company_name,:company_shname,:company_id,:furnizor_id).distinct.order(company_shname: :asc)
      @leaves  =  Vallmpoint.all
    elsif (current_user.has_role? :"cduser-fee") then 
      @navheader = 'FEE'
      @pages = Furnizor.where('upper(name) like upper(?)',"%fee%").order(name: :asc)
      @subpages = Vallmpoint.select(:company_name,:company_shname,:company_id,:furnizor_id).where('upper(furnizor) like upper(?)',"%fee%").distinct.order(company_shname: :asc)
      @leaves  = Vallmpoint.all    
    elsif (current_user.has_role? :"cduser-fenosa") then
      @navheader = 'FENOSA'
      @pages = Furnizor.where('upper(name) like upper(?)',"%fenosa%").order(name: :asc)
      @subpages = Vallmpoint.select(:company_name,:company_shname,:company_id,:furnizor_id).where('upper(furnizor) like upper(?)',"%fenosa%").distinct.order(company_shname: :asc)
      @leaves  = Vallmpoint.all   
    end 
    if (current_user.has_role? :setsu) or (current_user.has_role? :"setsu-nord") or (current_user.has_role? :"setsu-nord-vest") or (current_user.has_role? :"setsu-centru")  or (current_user.has_role? :"setsu-sud")  then 
      @navheader = 'Филиалы'
      @pages = Filial.all.order(name: :asc)
      @subpages = Vallmpoint.select(:company_name,:company_shname,:company_id,:filial_id).distinct.order(company_shname: :asc)
      @leaves  = Vallmpoint.all
    end
      @count_mpoints={}
      if !@subpages.nil?
         @subpages.each do |subitem|
         i=0  
         if !@leaves.nil?
            @leaves.each do |leaf|
               if subitem.company_id==leaf.company_id then i+=1 end                           
            end              
         end 
         if i==0 then @count_mpoints[subitem.company_id] = nil else @count_mpoints[subitem.company_id] = i end                      
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
