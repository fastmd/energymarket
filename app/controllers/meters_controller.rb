class MetersController < ApplicationController
before_filter :redirect_cancel, only: [:create, :update]
before_filter :check_user  
  
  def helpcounter
    @pagename = 'Справка-Счетчики'
    @mp =  Mpoint.find(params[:id]) 
  end
  
  def index
    @flag = params[:flag]  
    @mp =  Mpoint.find(params[:id]) 
    @cp  = @mp.company
    @meter = @mp.meters.build
    @meter.relevance_date = Date.current
    @met = @mp.meters.order('relevance_date desc nulls last', created_at: :desc)
    @met = @met.paginate(:page => params[:page], :per_page => @perpage = $PerPage)    
    @metertypes=Vmetertype.all.pluck(:cvalue, :id)
    if @fpr < 6 then  @flr =  @mp.mesubstation.filial else @flr =  @mp.furnizor end
  end

  def new
  end

  def create
    @mp =  Mpoint.find(params[:mpoint_id])
    @meter = @mp.meters.build
    @meter = meter_init(@meter)
    begin
      if @meter.save! then 
        flash.discard
        flash[:notice] = "Счетчик #{@meter.meternum} сохранен."
        redirect_to meters_index_path(:id => @meter.mpoint_id) 
      end
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'add'
      @met = @mp.meters.order('relevance_date desc nulls last', created_at: :desc) 
      @met = @met.paginate(:page => params[:page], :per_page => @perpage = $PerPage)
      @metertypes=Vmetertype.all.pluck(:cvalue, :id)
      render 'index'
    end   
  end

  def update
    @meter = Meter.find(params[:id])
    @meter = meter_init(@meter)
    @mp  = @meter.mpoint
    begin
      if @meter.save! then
        flash.discard
        flash[:notice] = "Счетчик #{@meter.meternum} сохранен." 
        redirect_to meters_index_path(:id => @meter.mpoint_id) 
      end
    rescue
      flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
      @flag = 'edit'
      @met = @mp.meters.order('relevance_date desc nulls last', created_at: :desc) 
      @met = @met.paginate(:page => params[:page], :per_page => @perpage = $PerPage)
      @metertypes=Vmetertype.all.pluck(:cvalue, :id)
      render 'index'
    end      
  end
  
  def edit
    @flag = 'edit'
    @meter = Meter.find(params[:mt_id])
    @mp  = @meter.mpoint
    @cp  = @mp.company
    @met = @mp.meters.order('relevance_date desc nulls last', created_at: :desc) 
    @met = @met.paginate(:page => params[:page], :per_page => @perpage = $PerPage)
    thesauruses=Vmetertype.all
    @metertypes=thesauruses.collect{|x| [x.cvalue,x.id]} 
    flash.discard 
    render :index
  end

  def show
    @met =  Meter.find(params[:id])
    @mp = @met.mpoint
    @mvs_all_pages = Vallmetersmvalue.where("?=id",@met.id).order(actdate: :desc, updated_at: :desc)        
    respond_to do |format|
      format.html
      format.pdf { send_data MpointsReport.new.to_pdf(@mvs_all_pages,@mp), :type => 'application/pdf', :filename => "history.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="history.xlsx"' }
    end       
  end
  
  def destroy
    meter = Meter.find(params[:mt_id])
    mp = Mpoint.find(meter.mpoint_id)
    mv_count = meter.mvalues.count
    if  mv_count!=0 then 
      flash[:warning] = "Нельзя удалить счетчик  № #{meter.meternum}, которому принадлежат показания (#{mv_count} шт.)" 
    else 
      meter.destroy
      flash[:notice] = "Счетчик #{meter.meternum} удален." 
    end
    redirect_to meters_path(:id => mp.id)
  end
  
private

  def redirect_cancel
    if params[:cancel] then
      mp = Mpoint.find(params[:mpoint_id])
      flash.discard 
      redirect_to meters_path(:id => mp.id, :flag => nil)
    end   
  end
  
  def meter_init(meter)
    ddd=params[:koeftt].to_s
    ddd=ddd.scan(/[0-9]{1,}/)
    if ddd[0].nil? then kt1 = 1 else kt1 = ddd[0].to_i end
    if (ddd[1].nil? or ddd[1].to_i == 0) then kt2 = 1 else kt2 = ddd[1].to_i end    
    koeftt = kt1.to_s + " / " + kt2.to_s
    ddd=params[:koeftn].to_s
    ddd=ddd.scan(/[0-9]{1,}/)
    if ddd[0].nil? then kn1 = 1 else kn1 = ddd[0].to_i end
    if (ddd[1].nil? or ddd[1].to_i == 0) then kn2 = 1 else kn2 = ddd[1].to_i end     
    koeftn = kn1.to_s + " / " + kn2.to_s
    koefcalc = (kt1.to_f * kn1.to_f) / (kt2.to_f * kn2.to_f)   
    meter.thesauru_id = params[:thesauru_id]
    meter.meternum = params[:meternum]
    meter.relevance_date = params[:relevance_date]
    meter.comment = params[:comment]
    meter.f = if params[:f].nil? then false else true end
    meter.koeftt = koeftt
    meter.koeftn = koeftn
    meter.koefcalc = koefcalc.round(4)
    meter.beforedigs = if params[:beforedigs] then params[:beforedigs] else 6 end
    meter.afterdigs = if params[:afterdigs] then params[:afterdigs] else 4 end 
    meter    
  end
  
end
