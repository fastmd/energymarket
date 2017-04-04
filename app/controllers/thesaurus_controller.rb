class ThesaurusController < ApplicationController
  before_filter :check_user
  before_filter :redirect_cancel, only: [:create, :update]  
  
  def index
    indexview
    if params[:th_id].nil? then @thesauru = Thesauru.new else @thesauru = Thesauru.find(params[:th_id]) end
    @flag = params[:flag]
  end 
  
  def new
  end 
  
  def create
    @flag = 'add'
    @thesauru = Thesauru.new
    @thesauru = thesauru_init(@thesauru)
    @current = @thesauru.name
    thesauru_save
  end
  
  def update
    @flag = 'edit' 
    @thesauru = Thesauru.find(params[:id])
    @thesauru = thesauru_init(@thesauru)
    @current = @thesauru.name   
    thesauru_save 
  end
  
  def edit
    thesauru = Thesauru.find(params[:th_id])
    flash.discard 
    redirect_to thesaurus_index_path(:flag => 'edit',:th_id => thesauru.id)   
  end
  
  def destroy
    thesauru = Thesauru.find(params[:th_id])
    @current = thesauru.name
    case thesauru.name when 'meter'  then th_count = thesauru.meters.count
                       when 'region' then th_count = thesauru.companies.count
                       else  th_count = 0   
    end
    if th_count!=0 then 
      flash[:warning] = "Нельзя #{thesauru.cvalue}, которому принадлежат объекты (#{th_count} шт.)" 
    else thesauru.destroy 
    end
    redirect_to thesaurus_index_path
  end

private

  def indexview
    @pagename = 'Справочник'
    @metertypes = Thesauru.where("name = ?", 'meter').order(:cvalue, :created_at)
    @regions = Thesauru.where("name = ?", 'region').order(:cvalue, :created_at)
    @sstations = Thesauru.where("name = ?", 'sstation').order(:cvalue, :created_at)
    @transformers = Thesauru.where("name = ?", 'transformer').order(:cvalue, :created_at)
    @lines = Thesauru.where("name = ?", 'line').order(:cvalue, :created_at)
    @thesaurus = @metertypes
    @names=[['Тип счетчика','meter'], ['Регион','region'], ['Подстанция','sstation'], ['Тип трансформатора','transformer'], ['Линия','line']] 
  end
  
  def thesauru_save
    t = Thesauru.where("name = ? and UPPER(cvalue) = ?", @thesauru.name, (@thesauru.cvalue).upcase).count
    if t !=0 then
      flash[:warning] = "Такой объект уже существует. Проверьте правильность ввода."       
      indexview
      render 'index'      
    else
      begin
        if @thesauru.save! then 
          flash.discard
          flash[:notice] = "#{@thesauru.cvalue} сохранен." 
          redirect_to thesaurus_index_path
        end
      rescue
        flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
        indexview
        render 'index'
      end
    end      
  end

  def redirect_cancel
    if params[:cancel] then
      flash.discard 
      redirect_to thesaurus_index_path(:flag => nil)
    end   
  end
  
  def thesauru_init(thesauru)
    thesauru.name = params[:name]
    t = params[:cvalue]
    t = t.lstrip
    t = t.rstrip
    thesauru.cvalue = t
    thesauru.f = if params[:f].nil? then false else true end
    thesauru    
  end
 
end
