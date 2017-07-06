class TransformatorsController < ApplicationController
  before_action :check_user
  before_action :redirect_cancel, only: [:create, :update]

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
  
  def show
    redirect_to transformators_index_path(:page => params[:page])
  end
  
  def create
    @flag = 'add'
    @transformator = Transformator.new(transformator_params)
    @transformator = transformator_init(@transformator)
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
    transformator_save
  end 
  
  def destroy
    transformator = Transformator.find(params[:id])
    ss_count = transformator.mpoints.count
    if ss_count!=0 then 
      flash[:warning] = "Нельзя удалить трансформатор #{transformator.name}, которому принадлежат точки учета (#{ss_count} шт.)" 
    else transformator.destroy 
    end
    redirect_to transformators_index_path(:page => @page)
  end  
  
private  

  def indexviewall
    @funoms = Transformator.select(:unom).distinct.order(unom: :asc).pluck(:unom)
    @fsnoms = Transformator.select(:snom).distinct.order(snom: :asc).pluck(:snom)
    @fukzs = Transformator.select(:ukz).distinct.order(ukz: :asc).pluck(:ukz)
    #-----------------------------
    if params[:filter] then
        cookies[:transformator_qunom] = @qunom = params[:qunom].to_s
        cookies[:transformator_qsnom] = @qsnom = params[:qsnom].to_s
        cookies[:transformator_qukz] = @qukz = params[:qukz].to_s
        @data_for_search = ''
        cookies.delete(:transformator_search)  
    else
        if params[:search] then
            cookies[:transformator_search] = @data_for_search = params[:transformator_search].to_s
            cookies.delete(:transformator_qunom)
            cookies.delete(:transformator_qsnom)
            cookies.delete(:transformator_qukz)         
        else
            @data_for_search = cookies[:transformator_search]
            unless (@data_for_search.nil? or @data_for_search.empty?) then 
              cookies.delete(:transformator_qunom)
              cookies.delete(:transformator_qsnom)
              cookies.delete(:transformator_qukz) 
            end
        end
        @qunom= cookies[:transformator_qunom]
        @qsnom = cookies[:transformator_qsnom]
        @qukz = cookies[:transformator_qukz]
    end 
    if @data_for_search.nil? or @data_for_search.empty? then
      if (@qunom.nil? or @qunom.empty?) and (@qsnom.nil? or @qsnom.empty?) and (@qukz.nil? or @qukz.empty?) then   
           @transformators = Transformator.all.order(unom: :asc, snom: :asc, ukz: :asc, name: :asc)
      else  
           @transformators = Transformator.where("(?='' or unom=?) and (?='' or trim(to_char(snom,'99999999.9')) like ?) and (?='' or trim(to_char(ukz,'99999999.9')) like ? or trim(to_char(ukz,'99999999.99')) like ?)", 
                               @qunom, @qunom, @qsnom, @qsnom, @qukz, @qukz, @qukz).order(unom: :asc, snom: :asc, ukz: :asc, name: :asc)      
      end  
    else
       @data_for_search = @data_for_search.upcase
       data_for_search = "%" + @data_for_search + "%"
       @transformators = Transformator.where("upper(name) like upper(?) ", data_for_search).order(unom: :asc, snom: :asc, ukz: :asc, name: :asc)
    end 
    #-----------------------------     
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
    params.require(:transformator).permit(:pxx,:pkz,:snom,:ukz,:i0,:name,:comment,:f,:unom)
  end
  
  def transformator_init(transformator)
    ukz2 = (transformator_params[:ukz].to_f) * (transformator_params[:ukz].to_f)
    snom2 = (transformator_params[:snom].to_f) * (transformator_params[:snom].to_f)
    pkz2 = (transformator_params[:pkz].to_f) * (transformator_params[:pkz].to_f)
    tmp = (ukz2 * snom2) / 10000 - pkz2
    if (tmp >= 0) then
      tmp = Math.sqrt(tmp).round(10)
    else
      tmp = nil  
    end
    transformator.unom = transformator_params[:unom]
    transformator.pxx = transformator_params[:pxx]
    transformator.pkz = transformator_params[:pkz]
    transformator.snom = transformator_params[:snom]
    transformator.ukz = transformator_params[:ukz]
    transformator.i0 = transformator_params[:i0]
    transformator.qkz = tmp   
    transformator.name = (transformator_params[:name]).lstrip.rstrip
    transformator.comment = transformator_params[:comment] 
    transformator.f = transformator_params[:f] 
    transformator    
  end
   
end
