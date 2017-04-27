class MesubstationsController < ApplicationController
  before_filter :check_user
  before_filter :redirect_cancel, only: [:create, :update]

  def index
    if params[:id].nil? then
      @mesubstation = Mesubstation.new
    else
      @mesubstation = Mesubstation.find(params[:id])
    end 
    indexviewall 
    @flag = params[:flag]
  end
  
  def new
  end
  
  def create
    @flag = 'add'
    @mesubstation = Mesubstation.new(mesubstation_params)
    mesubstation_save
  end

  def edit
    mesubstation = Mesubstation.find(params[:id])
    flash.discard 
    redirect_to mesubstations_index_path(:flag => 'edit',:id => mesubstation.id)   
  end
  
  def update
    @flag = 'edit' 
    @mesubstation = Mesubstation.find(params[:id])
    @mesubstation = mesubstation_init(@mesubstation)
    mesubstation_save
  end 
  
  def destroy
    mesubstation = Mesubstation.find(params[:id])
    ss_count = mesubstation.mpoints.count
    if ss_count!=0 then 
      flash[:warning] = "Нельзя удалить подстанцию #{mesubstation.name}, которой принадлежат точки учета (#{ss_count} шт.)" 
    else mesubstation.destroy 
    end
    redirect_to mesubstations_index_path(:page => @page)
  end  
  
private  

  def indexviewall
    @mesubstations = Mesubstation.all.order(name: :asc)
    @page = params[:page] 
    if !@mesubstation.nil? && !@mesubstation.id.nil? then 
      i = 0
      n = 0
      @mesubstations.each do |item|
        if item.id == @mesubstation.id then n = i end
        i += 1   
      end
      @page = (n / $PerPage + 0.5).round       
    end  
    if @page.nil? then 
      @page = 1
    elsif !@mesubstations.nil? &&  @mesubstations.count < (@page.to_i - 1) * $PerPage then 
      @page = ((@mesubstations.count-1) / $PerPage + 0.5).round    
    end  
    unless @mesubstations.nil? then @mesubstations = @mesubstations.paginate(:page => @page, :per_page => $PerPage ) end              
  end  

  def mesubstation_save
    t = Mesubstation.where("cod = ? or UPPER(name) = ?", @mesubstation.cod, (@mesubstation.name).upcase).count
    if (t != 0) and (@mesubstation.nil?)  then
      flash[:warning] = "Такой объект уже существует. Проверьте правильность ввода."       
      indexviewall
      render 'index'      
    else
      begin
        if @mesubstation.save! then 
          @flag = nil
          flash.discard
          flash[:notice] = "Подстанция #{@mesubstation.name} сохранена." 
          indexviewall
          @mesubstation = Mesubstation.new
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
      redirect_to mesubstations_index_path(:flag => nil, :page => @page)
    end   
  end
  
  def mesubstation_params
    params.require(:mesubstation).permit(:name, :cod, :filial_id, :region_id, :f)
  end
  
  def mesubstation_init(mesubstation)  
    mesubstation.name = mesubstation_params[:name]
    mesubstation.cod = mesubstation_params[:cod] 
    mesubstation.f = mesubstation_params[:f]   
    mesubstation.filial_id = mesubstation_params[:filial_id]
    mesubstation.region_id = mesubstation_params[:region_id]
    mesubstation    
  end
   
end
