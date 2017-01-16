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
    ukz2 = params[:ukz].to_f * params[:ukz].to_f
    snom2 = params[:snom].to_f * params[:snom].to_f
    pkz2 = params[:pkz].to_f * params[:pkz].to_f
    tmp = (ukz2 * snom2) / 10000 - pkz2
   # if (tmp > 0)
      @tr.qkz = Math.sqrt(tmp).round(10) #Math.sqrt
      @tr.save
      params[:num] = @mp.id
      redirect_to :back, flash: {success: "Транформатор успешно создан."}
      return
    else
      redirect_to :back, flash: {error: "Введенные вами данные не верны."}
      return
    end  
    redirect_to mpoint_path(@mp)
  end
  
  def new
  end

  def edit
    @tr = Trparam.find(params[:tr_id])
    @mp = Mpoint.find(params[:id])
    params[:mp_id] = @mp.id
  end
  
  def update
    @tr = Trparam.find(params[:tr_id])
    @mp = Mpoint.find(@tr.mpoint_id)
    #params[:mp_id] = @mp.id
    
    @tr.pxx = params[:pxx].to_f
    @tr.pkz = params[:pkz].to_f
    @tr.snom = params[:snom].to_f
    @tr.ukz = params[:ukz].to_f
    @tr.io = params[:io].to_f
    @tr.save
    redirect_to mpoint_path(@mp)
  end

  def show
    @tr = Trparam.find(params[:tr_id])
    @mp = Mpoint.find(params[:id])
    params[:mp_id] = @mp.id
  end

  def index
  end
  
  def export
  end
end
