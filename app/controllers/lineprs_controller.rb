class LineprsController < ApplicationController
  def create
    @mp = Mpoint.find(params[:mpoint_id])
    #@mv = @mp.mvalues.create(params[:mvalue])
    @ln = @mp.lineprs.new
    @ln.p1 = params[:p1]
    @ln.l1 = params[:l1]
    @ln.save
    params[:num] = @mp.id
    redirect_to mpoint_path(@mp)
  end
  
  def new
    @mp = Mpoint.find(params[:mpoint_id])
    @ln = @mp.lineprs.create(linepr_params)
  #  redirect_to contract_path(@contract.id)
  end

  def edit
  end

  def show
  end

  def index
  end
end
