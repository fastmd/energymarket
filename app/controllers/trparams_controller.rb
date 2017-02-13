class TrparamsController < ApplicationController
before_filter :redirect_cancel, only: [:create, :update]
  
  def create  
    ukz2 = params[:ukz].to_f * params[:ukz].to_f
    snom2 = params[:snom].to_f * params[:snom].to_f
    pkz2 = params[:pkz].to_f * params[:pkz].to_f
    tmp = (ukz2 * snom2) / 10000 - pkz2
    if (tmp >= 0) 
      tmp = Math.sqrt(tmp).round(10)
    else
      tmp = nil  
    end 
    if params[:tr_id].nil? or params[:tr_id]=='' then
     @mp = Mpoint.find(params[:mpoint_id])  
     tr = @mp.trparams.new
    else
     tr = Trparam.find(params[:tr_id])
     @mp = Mpoint.find(tr.mpoint_id)
    end   
     tr.pxx = params[:pxx].to_f
     tr.pkz = params[:pkz].to_f
     tr.snom = params[:snom].to_f
     tr.ukz = params[:ukz].to_f
     tr.io = params[:io].to_f
     tr.qkz =  tmp
     tr.f = params[:f]
     tr.comment = params[:comment]
     if tr.save then redirect_to mpoint_path(@mp)
     else  
        if params[:tr_id].nil? or params[:tr_id]=='' then
          redirect_to mpoint_path(@mp,:pxx =>params[:pxx],:pkz=>params[:pkz],:snom=>params[:snom],:ukz=>params[:ukz],:io=>params[:io],:f=>params[:f],:comment=>params[:comment],:flag=>'tadd')
        else
          redirect_to mpoint_path(@mp,:tr_id=>tr.id,:pxx =>tr.pxx,:pkz=>tr.pkz,:snom=>tr.snom,:ukz=>tr.ukz,:io=>tr.io,:f=>tr.f,:comment=>tr.comment,:flag=>'tedit')
        end    
     end 
  end
  
  def edit
    @tr = Trparam.find(params[:tr_id])
    @mp = Mpoint.find(@tr.mpoint_id)
    redirect_to mpoint_path(@mp,:tr_id=>@tr.id,:pxx =>@tr.pxx,:pkz=>@tr.pkz,:snom=>@tr.snom,:ukz=>@tr.ukz,:io=>@tr.io,:f=>@tr.f,:comment=>@tr.comment,:flag=>'tedit')
  end
  
  def destroy
    @tr = Trparam.find(params[:tr_id])
    @mp = Mpoint.find(@tr.mpoint_id)
    @tr.destroy
    redirect_to mpoint_path(@mp)
  end
  
private

  def redirect_cancel
    @mp = Mpoint.find(params[:mpoint_id])
    redirect_to mpoint_path(@mp, :flag => nil) if params[:cancel]
  end    
end
