class LnparamsController < ApplicationController
before_filter :redirect_cancel, only: [:create, :update]  
  
  def create
    if params[:line_id].nil? or params[:line_id]=='' then
      @mp = Mpoint.find(params[:mpoint_id])
      line = @mp.lnparams.new
    else
      line = Lnparam.find(params[:line_id])
      @mp = Mpoint.find(line.mpoint_id)
    end 
    tmp = params[:k_scr].to_f * params[:k_tr].to_f * params[:k_peb].to_f  * params[:ro].to_f * params[:l].to_f * 1000
    if (params[:q].to_f != 0) then tmp = tmp / params[:q].to_f end 
    line.l = params[:l]
    line.ro = params[:ro]
    line.k_scr = params[:k_scr]
    line.k_tr = params[:k_tr]
    line.k_peb = params[:k_peb] 
    line.k_f = params[:k_f] 
    line.q = params[:q]
    line.f = if params[:f].nil? then false else true end
    line.r = tmp  
    line.comment = params[:comment]
    if line.save then redirect_to mpoint_path(@mp)
    else  
       flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."
       if params[:line_id].nil? or params[:line_id]=='' then
          redirect_to mpoint_path(@mp,:r =>params[:r],:l=>params[:l],:ro =>params[:ro],:k_scr =>params[:k_scr],
                                  :k_tr =>params[:k_tr],:k_peb =>params[:k_peb],:k_f =>params[:k_f],:q =>params[:q],:f =>params[:f],:comment=>params[:comment],:flag=>'ladd')
       else
          redirect_to mpoint_path(@mp,:line_id=>line.id,:l=>line.l,:ro=>line.ro,:k_scr=>line.k_scr,:k_tr=>line.k_tr,
                                  :k_peb=>line.k_peb,:k_f=>line.k_f,:q=>line.q,:f=>line.f,:comment=>line.comment,:flag=>'ledit')
       end    
    end     
  end
  
  def edit
    @line = Lnparam.find(params[:line_id])
    @mp = Mpoint.find(@line.mpoint_id)
    redirect_to mpoint_path(@mp,:line_id=>@line.id,:l=>@line.l,:ro=>@line.ro,:k_scr=>@line.k_scr,:k_tr=>@line.k_tr,
                                  :k_peb=>@line.k_peb,:k_f=>@line.k_f,:q=>@line.q,:f=>@line.f,:comment=>@line.comment,:flag=>'ledit')
  end
 
  def destroy
    @line = Lnparam.find(params[:line_id])
    @mp = Mpoint.find(@line.mpoint_id)
    @line.destroy
    redirect_to mpoint_path(@mp)
  end

private

  def redirect_cancel
    @mp = Mpoint.find(params[:mpoint_id])
    redirect_to mpoint_path(@mp, :flag => nil) if params[:cancel]
  end  
    
end
