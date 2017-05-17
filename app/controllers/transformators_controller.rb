class TransformatorsController < ApplicationController
  before_filter :check_user
  before_filter :redirect_cancel, only: [:create, :update]

  def index
    if params[:id].nil? then
      @transformator = Transformator.new
    else
      @transformator = Transformator.find(params[:id])
    end 
    indexviewall 
    @flag = params[:flag]
  end
  
  def new
  end
  
  def create
    @flag = 'add'
    @transformator = Transformator.new(transformator_params)
    transformator_save
  end

  def edit
    transformator = Transformator.find(params[:id])
    flash.discard 
    redirect_to transformators_index_path(:flag => 'edit',:id => transformator.id)   
  end
  
  def update
    @flag = 'edit' 
    @transformator = Transformator.find(params[:id])
    @transformator = transformator_init(@transformator)
    mesubstation_save
  end 
  
  def destroy
    transformator = Transformator.find(params[:id])
    ss_count = transformator.mpoints.count
    if ss_count!=0 then 
      flash[:warning] = "Нельзя удалить трансформатор #{transformator.name}, которому принадлежат точки учета (#{ss_count} шт.)" 
    else transformator.destroy 
    end
    redirect_to transformator_index_path(:page => @page)
  end  
  
private  

  def indexviewall
    @transformators = Transformator.all.order(name: :asc)
    @page = params[:page] 
    if !@transformator.nil? && !@transformator.id.nil? then 
      i = 0
      n = 0
      @transformators.each do |item|
        if item.id == @transformator.id then n = i end
        i += 1   
      end
      @page = (n / $PerPage + 0.5).round       
    end  
    if @page.nil? then 
      @page = 1
    elsif !@transformators.nil? &&  @transformators.count < (@page.to_i - 1) * $PerPage then 
      @page = ((@transformators.count-1) / $PerPage + 0.5).round    
    end  
    unless @transformators.nil? then @transformators = @transformators.paginate(:page => @page, :per_page => $PerPage ) end              
  end  

  def transformator_save
    t = Transformator.where("UPPER(name) = ?", (@transformator.name).upcase).count
    if (t != 0) and (@transformator.nil?)  then
      flash[:warning] = "Такой объект уже существует. Проверьте правильность ввода."       
      indexviewall
      render 'index'      
    else
      begin
        if @transformator.save! then 
          @flag = nil
          flash.discard
          flash[:notice] = "Трансформатор #{@transformator.name} сохранен." 
          indexviewall
          @transformator = Transformator.new
          render 'index' 
        end
      rescue
        flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
        indexviewall
        render 'index'
      end
    end      
  end

  def redirect_cancel
    if params[:cancel] then
      flash.discard 
      redirect_to transformators_index_path(:flag => nil, :page => @page)
    end   
  end
  
  def transformator_params
    params.require(:transformator).permit(:name, :cod, :filial_id, :region_id, :f)
  end
  
  def transformator_init(transformator)  
    transformator.name = transformator_params[:name]
    transformator.cod = transformator_params[:cod] 
    transformator.f = transformator_params[:f]   
    transformator.filial_id = transformator_params[:filial_id]
    transformator.region_id = transformator_params[:region_id]
    transformator    
  end
   
end
