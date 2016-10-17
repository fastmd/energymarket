class MvaluesController < ApplicationController
  
  def create
    @mp = Mpoint.find(params[:mpoint_id])
    #@mv = @mp.mvalues.create(params[:mvalue])
    @mv = @mp.mvalues.new
    @mv.val = params[:val]
    @mv.comment = params[:comment]
    @mv.save
    params[:num] = @mp.id
    redirect_to mpoint_path(@mp)
  end
  
  def new
    @mp = Mpoint.find(params[:mpoint_id])
    @mv = @mp.mvalues.create(mvalue_params)
  #  redirect_to contract_path(@contract.id)
  end

  def edit
  end

  def show
  end

  def index
  end
end
