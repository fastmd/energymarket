class LineprsController < ApplicationController
  def create
    @mp = Mpoint.find(params[:mpoint_id])
    @line = @mp.lineprs.new
    @line.p1 = params[:p1]
    @line.l1 = params[:l1]
    @line.comment = params[:comment]
    @line.save
    params[:num] = @mp.id
    redirect_to mpoint_path(@mp)
  end
  
  def edit
  end
 
  def destroy
    @line = Linepr.find(params[:line_id])
    @mp = Mpoint.find(@line.mpoint_id)
    @line.destroy
    redirect_to mpoint_path(@mp)
  end
    
end
