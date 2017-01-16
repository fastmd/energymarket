class MvaluesController < ApplicationController
  
  def create
    @mp = Mpoint.find(params[:mpoint_id])
    @mv = @mp.mvalues.new
    @mv.meter_id = params[:meter_id]
    @mv.actp180 = params[:actp180]
    @mv.actp280 = params[:actp280]
    @mv.actp380 = params[:actp380]
    @mv.actp480 = params[:actp480]
    @mv.actdate = params[:actdate]
    @mv.comment = params[:comment]
    @mv.save
    redirect_to mpoint_path(@mp,:flag => 1,:met => params[:met])
  end
  
  def new
  end

  def edit
  end

  def show
  end

  def index
  end
end
