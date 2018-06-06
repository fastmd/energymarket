class WelcomeController < ApplicationController
before_action :check_user
helper_method :sort_column, :sort_direction   
  
  def index
   if @fpr.nil? then
     flash[:warning] = "Нет прав доступа !"    
   else  
    if @fpr < 6 then
       @flr = Filial.all.order("#{sort_column} #{sort_direction}")
       @pagename = 'Филиалы'    
    elsif @fpr == 6 then
       @flr = Furnizor.all.order("#{sort_column} #{sort_direction}") 
       @pagename = 'Поставщики' 
    elsif @fpr == 7 then
       @flr = Furnizor.where('upper(name) like upper(?)',"%fee%").order("#{sort_column} #{sort_direction}") 
       @pagename = 'FEE'     
    elsif @fpr == 8 then
       @flr = Furnizor.where('upper(name) like upper(?)',"%fenosa%").order("#{sort_column} #{sort_direction}") 
       @pagename = 'Fenosa' 
    end
    unless  @flr.nil? then  
      @flr = @flr.paginate(:page => params[:page], :per_page => @perpage = $PerPage)
    end
   end  
  end
  
  def help
    @pagename = 'Справка'
  end

  def thesaurus
    @pagename = 'Справка-Справочник'
  end
 
  def counter
    @pagename = 'Справка-Счетчики'
  end
  
  def mvalue
    @pagename = 'Справка-Показания'
  end
  
  def mpoint
    @pagename = 'Справка-Точки учета'
  end  
  
private
  def sortable_columns
    ["name"]
  end

  def sort_column
    sortable_columns.include?(params[:column]) ? params[:column] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end  
   
end  
