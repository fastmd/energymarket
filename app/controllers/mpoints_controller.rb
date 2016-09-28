class MpointsController < ApplicationController
  def new
  end

  def show
     @mp =  Mpoint.find(params[:id])
     @mv =  @mp.mvalues.all
  end

  def index
  end

  def edit
  end
end
