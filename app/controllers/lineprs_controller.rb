class LineprsController < ApplicationController
  def create
    if params[:line_id].nil? or params[:line_id]=='' then
      @mp = Mpoint.find(params[:mpoint_id])
      line = @mp.lineprs.new
    else
      line = Linepr.find(params[:line_id])
      @mp = Mpoint.find(line.mpoint_id)
    end   
    line.p1 = params[:p1]
    line.l1 = params[:l1]
    line.comment = params[:comment]
    if line.save then redirect_to mpoint_path(@mp)
    else  
       if params[:line_id].nil? or params[:line_id]=='' then
          redirect_to mpoint_path(@mp,:p1 =>params[:p1],:l1=>params[:l1],:comment=>params[:comment],:flag=>'ladd')
       else
          redirect_to mpoint_path(@mp,:line_id=>@line.id,:p1 =>@line.p1,:l1=>@line.l1,:comment=>@line.comment,:flag=>'ledit')
       end    
    end     
  end
  
  def edit
    @line = Linepr.find(params[:line_id])
    @mp = Mpoint.find(@line.mpoint_id)
    redirect_to mpoint_path(@mp,:line_id=>@line.id,:p1=>@line.p1,:l1=>@line.l1,:comment=>@line.comment,:flag=>'ledit')
  end
 
  def destroy
    @line = Linepr.find(params[:line_id])
    @mp = Mpoint.find(@line.mpoint_id)
    @line.destroy
    redirect_to mpoint_path(@mp)
  end
    
end
