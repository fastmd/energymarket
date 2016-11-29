class WelcomeController < ApplicationController
  def index
    if current_user.has_role? :cduser
      redirect_to welcome_cdindex_path
    end 
    
    if current_user.has_role? :setsu
      redirect_to welcome_setsuindex_path
    end
    
    @furns = Furnizor.all
    @filials = Filial.all
    @companies = Company.all
    
    
    
  end
  
  def cdindex
     @furns = Furnizor.all
    @companies = Company.all
  end
  
  def setsuindex 
    @furns = Furnizor.all
    @filials = Filial.all
    @companies = Company.all
  end
  
 
  
end
