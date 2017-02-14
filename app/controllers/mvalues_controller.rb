class MvaluesController < ApplicationController
before_filter :redirect_cancel, only: [:create, :update]
 
  def create
    mp = Mpoint.find(params[:mpoint_id])
    if params[:mv_id].nil? or params[:mv_id]=='' then
      mv = Mvalue.new
    else
      mv = Mvalue.find(params[:mv_id])
    end 
    mv.meter_id = params[:meter_id]
    mv.actp180 = params[:actp180]
    mv.actp280 = params[:actp280]
    mv.actp380 = params[:actp380]
    mv.actp480 = params[:actp480]
    mv.actdate = params[:actdate]
    mv.comment = params[:comment]
    if mv.save then redirect_to mpoint_path(mp, :met => params[:met])
    else        
        if params[:mv_id].nil? or params[:mv_id]=='' then
          redirect_to mpoint_path(mp,:meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280=>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                                     :actp380=>params[:actp380],:actdate =>params[:actdate],:comment=>params[:comment],:flag=>'mvadd',:met=>params[:met])
        else
          redirect_to mpoint_path(mp,:mv_id=>mv.id,
                                     :meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280 =>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                                     :actp380=>params[:actp380],:actdate=>params[:actdate],:comment=>params[:comment],:flag=>'mvedit',:met=>params[:met])
        end    
     end 
  end
  
  def new
  end

  def edit
    mv = Mvalue.find(params[:mv_id])
    met = mv.meter
    mp  = met.mpoint
    redirect_to mpoint_path(mp, :flag=>'mvedit', :met => params[:met], :mv_id => mv.id, 
                                :meter_id=>mv.meter_id,:actp180=>mv.actp180,:actp280=>mv.actp280,:actp380=>mv.actp380,:actp480=>mv.actp480,
                                :actp380=>mv.actp380,:actdate=>mv.actdate,:comment=>mv.comment)
  end

  def show
  end

  def index
  end
  
  def destroy
    mv = Mvalue.find(params[:mv_id])
    met = Meter.find(mv.meter_id)
    mp = Mpoint.find(met.mpoint_id)    
    mv.destroy
    redirect_to mpoint_path(mp)
  end
  
private

  def redirect_cancel
    mp = Mpoint.find(params[:mpoint_id])
    redirect_to mpoint_path(mp, :flag => nil, :met => params[:met]) if params[:cancel]
  end
     
end
