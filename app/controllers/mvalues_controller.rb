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
    mv.trab = params[:trab]
    mv.dwa = params[:dwa]
    mv.undercount = params[:undercount]
    mv.actdate = params[:actdate]
    mv.comment = params[:comment]
    mv.f = if params[:f].nil? then false else true end
    mv.r = if params[:r].nil? then false else true end
    mv.fanulare = if params[:fanulare].nil? then nil else true end        
    begin  
      if mv.save! then redirect_to mpoint_path(mp, :met => params[:met]) end
    rescue
          flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
          if params[:mv_id].nil? or params[:mv_id]=='' then
            redirect_to mpoint_path(mp,:meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280=>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                                       :trab=>params[:trab],:dwa=>params[:dwa],:undercount=>params[:undercount], 
                                       :actdate =>params[:actdate],:comment=>params[:comment],:f=>params[:f],:r=>params[:r],:fanulare=>params[:fanulare],:flag=>'mvadd',:met=>params[:met])
          else
            redirect_to mpoint_path(mp,:mv_id=>mv.id,
                                       :meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280 =>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                                       :trab=>params[:trab],:dwa=>params[:dwa],:undercount=>params[:undercount],
                                       :actdate=>params[:actdate],:comment=>params[:comment],:f=>params[:f],:r=>params[:r],:fanulare=>params[:fanulare],:flag=>'mvedit',:met=>params[:met])
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
                                :trab=>mv.trab,:dwa=>mv.dwa,:undercount=>mv.undercount,
                                :actdate=>mv.actdate,:comment=>mv.comment,:f=>mv.f,:r=>mv.r,:fanulare=>mv.fanulare)
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
