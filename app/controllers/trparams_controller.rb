class TrparamsController < ApplicationController
  def create
    @mp = Mpoint.find(params[:mpoint_id])
    #@mv = @mp.mvalues.create(params[:mvalue])
    @tr = @mp.trparams.new
    @tr.pxx = params[:pxx]
    @tr.pkz = params[:pkz]
    @tr.snom = params[:snom]
    @tr.save
    params[:num] = @mp.id
    redirect_to mpoint_path(@mp)
  end
  
  def new
    @mp = Mpoint.find(params[:mpoint_id])
    @tr = @mp.trparams.create(trparam_params)
  #  redirect_to contract_path(@contract.id)
  end

  def edit
  end

  def show
  end

  def index
  end
end
