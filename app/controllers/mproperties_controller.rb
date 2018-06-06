class MpropertiesController < ApplicationController
  before_action :check_user
  before_action :redirect_cancel, only: [:create, :update]

  def index
    if params[:id].nil? then
      @mproperty = Mproperty.new
      #@mproperty.propdate = DateTime.current().beginning_of_day()
    else
      @mproperty = Mproperty.find(params[:id])
    end 
    indexviewall 
    @flag = params[:flag]
  end
  
  def show
    redirect_to company_path(:flag => nil, :id => params[:company_id], :flr_id => params[:flr_id])
  end
  
  def new
  end
  
  def create
    @flag = 'deepadd'
    @mproperty = Mproperty.new(mproperty_params)
    mproperty_save
  end

  def edit
    mproperty = Mproperty.find(params[:id])
    flash.discard 
    redirect_to company_path(:flag => 'deepedit',:id => mproperty.id)   
  end
  
  def update
    @flag = 'deepadd'
    @mproperty = Mproperty.find(params[:id])
    @mproperty = mproperty_init(@mproperty)
    #render inline: "<%= params.inspect %><br><br><%= @mproperty.inspect %><br><br>" and return
    mproperty_save
  end 
  
  def destroy
    @mproperty = Mproperty.find(params[:id])
    #render inline: "<%= @mproperty.inspect %><br><br>" and return
    begin
        if @mproperty.destroy! then          
          flash[:info] = "Запись от #{@mproperty.propdate.strftime("""%d.%m.%Y %H:%M""")} для точки учета #{@mproperty.mpoint_id} удалена." 
        end
      rescue
        flash[:error] = "Запись не удалена. #{@mproperty.errors.full_messages}"
        #render inline: "<%= @line.inspect %><br><br>" and return       
    end
    redirect_to company_path(:flag => nil, :id => params[:company_id], :flr_id => params[:flr_id])
  end  
  
private  

  def indexviewall
    @cp =  Company.find(params[:company_id])
    @mpoint = @cp.mpoints.build
    @companies = Company.where("id = ? and f = true", @cp.id)
    #-------------------------------  
    if @fpr < 6  then  
      @flr = Filial.find(params[:flr_id]) 
    else 
      @flr =  Furnizor.find(params[:flr_id])
      @mpoint.furnizor_id = params[:flr_id] 
    end
    #-------------------------------     
    @mp =  Vallmpoint.where(if @fpr < 6 then "filial_id = ? and company_id = ?" else "furnizor_id = ? and company_id = ?" end, @flr.id, @cp.id).order(name: :asc, created_at: :asc) 
    @sstations = Mesubstation.where("f = ?", true).order(name: :asc).pluck(:name, :id)
    @furns = if (@flr.nil? || (@fpr < 6)) then Furnizor.all.pluck(:name, :id)  else [[@flr.name, @flr.id]] end
    @fils  = if (@flr.nil? || (@fpr >= 6)) then Filial.all.pluck(:name, :id)   else [[@flr.name, @flr.id]] end
    #-------------------------------   
    @mpoints= Mpoint.where(if @fpr < 6 then "filial_id = ? and company_id = ?" else "furnizor_id = ? and company_id = ? and f = true" end, @flr.id, @cp.id).order(name: :asc, created_at: :asc)  
    gon.mpoints = @mpoints
  end  

  def mproperty_save
    flash.discard
    t = Mproperty.where("propdate = ? and mpoint_id = ? and (? is null or id != ?)", @mproperty.propdate, @mproperty.mpoint_id, @mproperty.id, @mproperty.id).count
    if (t != 0) then
      flash[:warning] = "Такой объект уже существует. Проверьте правильность ввода."       
      indexviewall
      render "companies/show"      
    else
      begin
        if @mproperty.save! then          
          flash[:notice] = "Запись от #{@mproperty.propdate.strftime("""%d.%m.%Y %H:%M""")} для точки учета #{@mproperty.mpoint_id} сохранена." 
          redirect_to company_path(:flag => nil, :id => params[:company_id], :flr_id => params[:flr_id])
        end
      rescue
        flash[:error] = "Данные не сохранены. #{@mproperty.errors.full_messages}"
        #render inline: "<%= @line.inspect %><br><br>" and return       
        indexviewall
        render "companies/show"
      end
    end      
  end

  def redirect_cancel
    if params[:cancel] then
      flash.discard 
      redirect_to company_path(:flag => nil, :id => (params[:company_id]), :flr_id => params[:flr_id])
    end   
  end
  
  def mproperty_params
    params.require(:mproperty).permit(:id,:propdate,:mpoint_id,:voltcl,:fct,:cosfi,:fctc,:four,:fturn,:fctl,:fmargin,:fminuslinelosses,:comment,:f)
  end
 
   def mproperty_init(mproperty)
    if !(mproperty_params['propdate(1i)'].nil?) then
      mproperty.propdate = DateTime.new( mproperty_params['propdate(1i)'].to_i, mproperty_params['propdate(2i)'].to_i, mproperty_params['propdate(3i)'].to_i, mproperty_params['propdate(4i)'].to_i, mproperty_params['propdate(5i)'].to_i )
    end      
    mproperty.mpoint_id = mproperty_params[:mpoint_id] 
    mproperty.voltcl = mproperty_params[:voltcl]
    mproperty.fct = unless mproperty_params[:fct] == "1" then false else true end 
    mproperty.cosfi = mproperty_params[:cosfi] 
    mproperty.fctc = unless mproperty_params[:fctc] == "1" then false else true end
    mproperty.four = unless mproperty_params[:four] == "1" then false else true end
    mproperty.fturn = unless mproperty_params[:fturn] == "1" then false else true end 
    mproperty.fctl = unless mproperty_params[:fctl] == "1" then false else true end 
    mproperty.fmargin = unless mproperty_params[:fmargin] == "1" then false else true end 
    mproperty.fminuslinelosses = unless mproperty_params[:fminuslinelosses] == "1" then false else true end             
    mproperty.comment = mylrstreep(mproperty_params[:comment])
    mproperty.f = if mproperty_params[:f].nil? then false else true end 
    mproperty    
  end 
   
end
