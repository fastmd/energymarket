class WelcomeController < ApplicationController
before_filter :check_user   
  
  def index
    if @fpr < 6 then
       @flr = Filial.all.order(name: :asc)
       @pagename = 'Филиалы'    
    elsif @fpr < 9 then
       @flr = Furnizor.all.order(name: :asc) 
       @pagename = 'Поставщики'         
    end
    unless  @flr.nil? then  
      @flr = @flr.paginate(:page => params[:page], :per_page => @perpage = $PerPage)
    end
  end
  
end  
