class LinesController < ApplicationController
  before_action :check_user
  before_action :redirect_cancel, only: [:create, :update]

  def index
    if params[:id].nil? then
      @line = Line.new
    else
      @line = Line.find(params[:id])
    end 
    indexviewall 
    @flag = params[:flag]
  end
  
  def show
    redirect_to lines_index_path(:page => params[:page])
  end
  
  def new
  end
  
  def create
    @flag = 'add'
    @line = Line.new(line_params)
    @line = line_init(@line)
    line_save
  end

  def edit
    line = Line.find(params[:id])
    flash.discard 
    redirect_to lines_index_path(:flag => 'edit',:id => line.id)   
  end
  
  def update
    @flag = 'edit' 
    @line = Line.find(params[:id])
    @line = line_init(@line)
    line_save
  end 
  
  def destroy
    line = Line.find(params[:id])
    ss_count = line.lnparams.count
    if ss_count!=0 then 
      flash[:warning] = "Нельзя удалить линию #{line.name}, которая принадлежит точкам учета (#{ss_count} шт.)" 
    else line.destroy 
    end
    redirect_to lines_index_path(:page => @page)
  end  
  
private  

  def indexviewall
    @ffils  = Filial.select(:name).distinct.order(name: :asc).pluck(:name) 
    @fregions = Thesauru.select(:cvalue).distinct.where("name = ? ", 'region').order(cvalue: :asc).pluck(:cvalue)
    @fsstations  = Mesubstation.select(:name).distinct.order(name: :asc).pluck(:name) 
    #-----------------------------
    if params[:filter] then
        $mesubstation_qregion = @qregion = params[:qregion].to_s
        $mesubstation_qfilial = @qfilial = params[:qfilial].to_s
        $line_qmesubstation = @qmesubstation = params[:qmesubstation].to_s
        @data_for_search = $line_search = '' 
    else
        if params[:search] then
            $line_search = @data_for_search = params[:line_search].to_s
            $mesubstation_qregion = ''
            $mesubstation_qfilial = ''
            $line_qmesubstation = ''          
        else
            @data_for_search = $line_search
            unless @data_for_search.empty? then $mesubstation_qregion = $mesubstation_qfilial = $line_qmesubstation = '' end
        end
        @qregion = $mesubstation_qregion
        @qfilial = $mesubstation_qfilial
        @qmesubstation = $line_qmesubstation
    end 
    if @data_for_search.empty? then
      if @qregion.empty? and @qfilial.empty? and @qmesubstation.empty? then   
           @lines = Vallline.all.order(filial_name: :asc, region_name: :asc, mesubstation_name: :asc, name: :asc, id: :asc)
      else  
           @lines = Vallline.where("(?='' or region_name=?) and (?='' or filial_name=?) and (?='' or mesubstation_name=?)", 
                               @qregion, @qregion, @qfilial, @qfilial, @qmesubstation, @qmesubstation).order(filial_name: :asc, region_name: :asc, mesubstation_name: :asc, name: :asc, id: :asc)      
      end  
    else
       @data_for_search = @data_for_search.upcase
       data_for_search = "%" + @data_for_search + "%"
       @lines = Vallline.where("upper(name) like upper(?) ", 
                               data_for_search).order(filial_name: :asc, region_name: :asc, mesubstation_name: :asc, name: :asc, id: :asc)
    end 
    #-----------------------------    
    @page = params[:page] 
    if !@line.nil? && !@line.id.nil? then 
      i = 0
      n = 0
      @lines.each do |item|
        if item.id == @line.id then n = i end
        i += 1   
      end
      @page = (n / $PerPage + 0.5).round       
    end  
    if @page.nil? then 
      @page = 1
    elsif !@lines.nil? &&  @lines.count < (@page.to_i - 1) * $PerPage then 
      @page = ((@lines.count-1) / $PerPage + 0.5).round    
    end  
    unless @lines.nil? then @lines = @lines.paginate(:page => @page, :per_page => $PerPage ) end              
  end  

  def line_save
    t = Line.where("UPPER(name) = ?", (@line.name).upcase).count
    if (t != 0) and (@line.nil?)  then
      flash[:warning] = "Такой объект уже существует. Проверьте правильность ввода."       
      indexviewall
      render 'index'      
    else
      begin
        if @line.save! then 
          @flag = nil
          flash.discard
          flash[:notice] = "Линия #{@line.name} сохранена." 
          indexviewall
          @line = Line.new
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
      redirect_to lines_index_path(:flag => nil, :page => @page)
    end   
  end
  
  def line_params
    params.require(:line).permit(:name,:l,:k_tr,:k_f,:wire_id,:mesubstation_id,:comment,:f)
  end
  
  def line_init(line)
    wire = Wire.find(line_params[:wire_id])
    if !wire.nil? and (wire.q.to_f != 0) then tmp = wire.k_scr.to_f * line_params[:k_tr].to_f * wire.k_peb.to_f  * wire.ro.to_f * line_params[:l].to_f * 1000 / wire.q.to_f else tmp = nil end 
    line.name = (line_params[:name]).lstrip.rstrip   
    line.l = line_params[:l]
    line.r  = tmp
    line.k_tr = line_params[:k_tr]
    line.k_f = line_params[:k_f]
    line.wire_id = line_params[:wire_id]
    line.mesubstation_id = line_params[:mesubstation_id]
    line.comment = line_params[:comment] 
    line.f = line_params[:f] 
    line    
  end
   
end
