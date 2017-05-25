class WiresController < ApplicationController
  before_action :check_user
  before_action :redirect_cancel, only: [:create, :update]

  def index
    if params[:id].nil? then
      @wire = Wire.new
    else
      @wire = Wire.find(params[:id])
    end 
    indexviewall 
    @flag = params[:flag]
  end
  
  def new
  end
  
  def show
    redirect_to wires_index_path(:page => params[:page])
  end
  
  def create
    @flag = 'add'
    @wire = Wire.new(wire_params)
    @wire = wire_init(@wire)
    wire_save
  end

  def edit
    wire = Wire.find(params[:id])
    flash.discard 
    redirect_to wires_index_path(:flag => 'edit',:id => wire.id)   
  end
  
  def update
    @flag = 'edit' 
    @wire = Wire.find(params[:id])
    @wire = wire_init(@wire)
    wire_save
  end 
  
  def destroy
    wire = Wire.find(params[:id])
    ss_count = wire.lines.count
    if ss_count!=0 then 
      flash[:warning] = "Нельзя удалить провод #{wire.name}, которому принадлежат линии (#{ss_count} шт.)" 
    else wire.destroy 
    end
    redirect_to wires_index_path(:page => @page)
  end  
  
private  

  def indexviewall
    @wires = Wire.all.order(q: :asc, name: :asc)
    @page = params[:page] 
    if !@wire.nil? && !@wire.id.nil? then 
      i = 0
      n = 0
      @wires.each do |item|
        if item.id == @wire.id then n = i end
        i += 1   
      end
      @page = (n / $PerPage + 0.5).round       
    end  
    if @page.nil? then 
      @page = 1
    elsif !@wires.nil? &&  @wires.count < (@page.to_i - 1) * $PerPage then 
      @page = ((@wires.count-1) / $PerPage + 0.5).round    
    end  
    unless @wires.nil? then @wires = @wires.paginate(:page => @page, :per_page => $PerPage ) end              
  end  

  def wire_save
    t = Wire.where("UPPER(name) = ?", (@wire.name).upcase).count
    if (t != 0) and (@wire.nil?)  then
      flash[:warning] = "Такой объект уже существует. Проверьте правильность ввода."       
      indexviewall
      render 'index'      
    else
      begin
        if @wire.save! then 
          @flag = nil
          flash.discard
          flash[:notice] = "Провод #{@wire.name} сохранен." 
          indexviewall
          @wire = Wire.new
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
      redirect_to wires_index_path(:flag => nil, :page => @page)
    end   
  end
  
  def wire_params
    params.require(:wire).permit(:name,:k_scr,:ro,:q,:k_peb,:comment,:f)
  end
  
  def wire_init(wire)
    wire.name = (wire_params[:name]).lstrip.rstrip
    wire.k_scr = wire_params[:k_scr]
    wire.ro = wire_params[:ro]
    wire.q = wire_params[:q]
    wire.k_peb = wire_params[:k_peb]
    wire.comment = wire_params[:comment] 
    wire.f = wire_params[:f] 
    wire    
  end
   
end
