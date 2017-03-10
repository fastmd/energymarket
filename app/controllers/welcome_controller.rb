class WelcomeController < ApplicationController
before_filter :check_user   
  
  def index
   if @fpr.nil? then
     flash[:warning] = "Нет прав доступа !"    
   else  
    if @fpr < 6 then
       @flr = Filial.all.order(name: :asc)
       @pagename = 'Филиалы'    
    elsif @fpr == 6 then
       @flr = Furnizor.all.order(name: :asc) 
       @pagename = 'Поставщики' 
    elsif @fpr == 7 then
       @flr = Furnizor.where('upper(name) like upper(?)',"%fee%").order(name: :asc) 
       @pagename = 'FEE'     
    elsif @fpr == 8 then
       @flr = Furnizor.where('upper(name) like upper(?)',"%fenosa%").order(name: :asc) 
       @pagename = 'Fenosa' 
    end
    unless  @flr.nil? then  
      @flr = @flr.paginate(:page => params[:page], :per_page => @perpage = $PerPage)
    end
   end  
  end
  
  def help
    @pagename = 'Помощь'
  end
   
end  
