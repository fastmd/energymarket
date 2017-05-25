class LnparamsController < ApplicationController
before_filter :check_user 
before_filter :redirect_cancel, only: [:create, :update]  

  def index
  end
      
  def new
  end
   
  def create
    @flag = 'ladd'
    @mp = Mpoint.find(lnparam_params[:mpoint_id])
    @lnparam = Lnparam.new(lnparam_params)
    lnparam_save
  end 
  
  def edit
    flash.discard 
    @lnparam = Lnparam.find(params[:ln_id])
    @mp = Mpoint.find(@lnparam.mpoint_id)
    redirect_to mpoint_path(@mp,:ln_id=>@lnparam.id,:flag=>'ledit')
  end
  
  def update
    @flag = 'edit'
    @mp = Mpoint.find(lnparam_params[:mpoint_id]) 
    @lnparam = Lnparam.find(params[:id])
    @lnparam = lnparam_init(@lnparam)
    lnparam_save
  end 
  
  def destroy
    @lnparam = Lnparam.find(params[:ln_id])
    @mp = Mpoint.find(@lnparam.mpoint_id)
    @lnparam.destroy
    redirect_to mpoint_path(@mp)
  end

private

  def redirect_cancel
     if params[:cancel] then   
        flash.discard
        @mp = Mpoint.find(lnparam_params[:mpoint_id]) 
        redirect_to mpoint_path(@mp, :flag => nil)
    end
  end
 
  def lnparam_save
      begin
        if @lnparam.save! then 
          flash.discard
          flash[:notice] = "Линия подключена."          
          redirect_to mpoint_path(@mp, :flag => nil)
        end          
      rescue
        flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."
        redirect_to mpoint_path(@mp,:ln_id=>@lnparam.id,:flag=>'ledit')     
      end    
  end
  
  def lnparam_params
    params.require(:lnparam).permit(:comment, :mpoint_id, :line_id, :f)
  end
    
  def lnparam_init(lnparam)
    lnparam.mpoint_id = lnparam_params[:mpoint_id]
    lnparam.line_id = lnparam_params[:line_id]
    lnparam.comment = lnparam_params[:comment]    
    lnparam.f = lnparam_params[:f]   
    lnparam    
  end   
    
end
