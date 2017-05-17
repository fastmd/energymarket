class TrparamsController < ApplicationController
before_filter :check_user  
before_filter :redirect_cancel, only: [:create, :update]
  
  def index
    if params[:id].nil? then
      @trparam = Trparam.new
    else
      @trparam = Trparam.find(params[:id])
    end 
    indexviewall 
    @flag = params[:flag]
  end
  
  def new
  end
  
  def create
    @flag = 'tadd'
    @mp = Mpoint.find(params[:mpoint_id])
    @tr = Trparam.new(trparam_params)
    trparam_save
  end  
  
  def edit
    @tr = Trparam.find(params[:tr_id])
    @mp = Mpoint.find(@tr.mpoint_id)
    redirect_to mpoint_path(@mp,:tr_id=>@tr.id,:f=>@tr.f,:comment=>@tr.comment,:transformator=>@tr.transformator,:flag=>'tedit')
  end
  
  def update
    @flag = 'edit'
    @mp = Mpoint.find(params[:mpoint_id]) 
    @tr = Trparam.find(params[:tr_id])
    @tr = trparam_init(@tr)
    trparam_save
  end 
  
  def destroy
    @tr = Trparam.find(params[:tr_id])
    @mp = Mpoint.find(@tr.mpoint_id)
    @tr.destroy
    redirect_to mpoint_path(@mp)
  end
  
private

  def indexviewall
    @trparams = Trparam.all.order(snom: :asc)
    @page = params[:page] 
    if !@trparam.nil? && !@trparam.id.nil? then 
      i = 0
      n = 0
      @trparams.each do |item|
        if item.id == @trparam.id then n = i end
        i += 1   
      end
      @page = (n / $PerPage + 0.5).round       
    end  
    if @page.nil? then 
      @page = 1
    elsif !@trparams.nil? &&  @trparams.count < (@page.to_i - 1) * $PerPage then 
      @page = ((@trparams.count-1) / $PerPage + 0.5).round    
    end  
    unless @trparams.nil? then @trparams = @trparams.paginate(:page => @page, :per_page => $PerPage ) end              
  end

  def redirect_cancel
    @mp = Mpoint.find(params[:mpoint_id])
    redirect_to mpoint_path(@mp, :flag => nil) if params[:cancel]
  end
 
  def trparam_save
      begin
          @tr.save! 
          @flag = nil
          flash.discard
          flash[:notice] = "Трансформатор #{@tr.name} сохранен."          
          redirect_to mpoint_path(@mp, :flag => nil)
          return          
      rescue
        flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."
        redirect_to mpoint_path(@mp,:tr_id=>@tr.id,:f=>@tr.f,:comment=>@tr.comment,:transformator=>@tr.transformator,:flag=>'tedit')       
      end    
  end
  
  def trparam_params
    params.require(:trparam).permit(:comment, :mpoint_id, :transformator_id, :f)
  end
    
  def trparam_init(trparam)
    trparam.mpoint_id = trparam_params[:mpoint_id]
    trparam.transformator_id = trparam_params[:transformator_id]
    trparam.comment = trparam_params[:comment]    
    trparam.f = trparam_params[:f]   
    trparam    
  end   
   
end
