class TrparamsController < ApplicationController
  def create
    @mp = Mpoint.find(params[:mpoint_id])
    #@mv = @mp.mvalues.create(params[:mvalue])
    @tr = @mp.trparams.new
    @tr.pxx = params[:pxx].to_f
    @tr.pkz = params[:pkz].to_f
    @tr.snom = params[:snom].to_f
    @tr.ukz = params[:ukz].to_f
    @tr.io = params[:io].to_f
    @tr.qkz = Math.sqrt(((params[:ukz].to_f*params[:ukz].to_f)*(params[:snom].to_f*params[:snom].to_f))/10000 - 
    ((params[:pkz].to_f*params[:pkz].to_f)))
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
