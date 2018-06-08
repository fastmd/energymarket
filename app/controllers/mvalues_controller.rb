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
    mv.actdate = mv.actdate.change(hour: (params[:date][:hour]).to_i, min: (params[:date][:minute]).to_i )
    mv.comment = params[:comment]
    mv.f = if params[:f].nil? then false else true end
    mv.r = if params[:r].nil? then false else true end
    mv.fanulare = if params[:fanulare].nil? then nil else true end
    mv.fnefact = if params[:fnefact].nil? then nil else true end
    mv.fnozero = if params[:fnozero].nil? then nil else true end 
    #@mv=mv  
    #render inline: "<%= params.inspect %><br><br><%= params[:date][:minute] %><br><br><%= @mv.inspect %><br><br>" and return           
    begin  
      if mv.save! then 
        flash[:notice] = "Показания сохранены."
        redirect_to mpoint_path(mp, :met => params[:met]) 
      end
    rescue
          mv.valid?
          flash[:warning] = "Данные не сохранены. Проверьте правильность ввода. #{mv.errors.full_messages}"       
          if params[:mv_id].nil? or params[:mv_id]=='' then
            redirect_to mpoint_path(mp,:meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280=>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                                       :trab=>params[:trab],:dwa=>params[:dwa],:undercount=>params[:undercount], 
                                       :actdate =>params[:actdate],:comment=>params[:comment],:f=>params[:f],:r=>params[:r],:fanulare=>params[:fanulare],
                                       :fnefact=>params[:fnefact],:fnozero=>params[:fnozero],:flag=>'mvadd',:met=>params[:met])
          else
            redirect_to mpoint_path(mp,:mv_id=>mv.id,
                                       :meter_id=>params[:meter_id],:actp180=>params[:actp180],:actp280 =>params[:actp280],:actp380=>params[:actp380],:actp480=>params[:actp480],
                                       :trab=>params[:trab],:dwa=>params[:dwa],:undercount=>params[:undercount],
                                       :actdate=>params[:actdate],:comment=>params[:comment],:f=>params[:f],:r=>params[:r],:fanulare=>params[:fanulare],
                                       :fnefact=>params[:fnefact],:fnozero=>params[:fnozero],:flag=>'mvedit',:met=>params[:met])
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
                                :actdate=>mv.actdate,:comment=>mv.comment,:f=>mv.f,:r=>mv.r,:fanulare=>mv.fanulare,:fnefact=>mv.fnefact,:fnozero=>mv.fnozero)
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
    flash[:notice] = "Показания удалены."
    redirect_to mpoint_path(mp)
  end
  
private

  def mvalue_params
    params.require(:mvalue).permit(:meter_id,:actp180,:actp280,:actp380,:actp480,:trab,:dwa,:undercount,:actdate,:r,:fanulare,:fnefact,:fnozero,:comment,:f)
  end

  def redirect_cancel
    mp = Mpoint.find(params[:mpoint_id])
    redirect_to mpoint_path(mp, :flag => nil, :met => params[:met]) if params[:cancel]
  end
     
end
