class TrparamsController < ApplicationController
before_filter :check_user  
before_filter :redirect_cancel, only: [:create, :update]
  
  def index
  end
  
  def new
  end
  
  def create
    @flag = 'tadd'
    @mp = Mpoint.find(trparam_params[:mpoint_id])
    @trparam = Trparam.new(trparam_params)
    trparam_save
  end  
  
  def edit
    flash.discard 
    @trparam = Trparam.find(params[:tr_id])
    @mp = Mpoint.find(@trparam.mpoint_id)
    redirect_to mpoint_path(@mp,:tr_id=>@trparam.id,:flag=>'tedit')
  end
  
  def update
    @flag = 'edit'
    @mp = Mpoint.find(trparam_params[:mpoint_id]) 
    @trparam = Trparam.find(params[:id])
    @trparam = trparam_init(@trparam)
    trparam_save
  end 
  
  def destroy
    @trparam = Trparam.find(params[:tr_id])
    @mp = Mpoint.find(@trparam.mpoint_id)
    @trparam.destroy
    redirect_to mpoint_path(@mp)
  end
  
private

  def redirect_cancel
     if params[:cancel] then   
        flash.discard
        @mp = Mpoint.find(trparam_params[:mpoint_id]) 
        redirect_to mpoint_path(@mp, :flag => nil)
    end
  end
 
  def trparam_save
      begin
        if @trparam.save! then 
          flash.discard
          flash[:notice] = "Трансформатор  подключен."          
          redirect_to mpoint_path(@mp, :flag => nil)
        end          
      rescue
        flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."
        redirect_to mpoint_path(@mp,:tr_id=>@trparam.id,:flag=>'tedit',:transformator_id=>@trparam.transformator_id,:comment=>@trparam.comment,:f=>@trparam.f)     
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
