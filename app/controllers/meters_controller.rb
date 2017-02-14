class MetersController < ApplicationController
  def index
    if current_user.has_role? :"setsu-nord"      then  @fpr = 1 end 
    if current_user.has_role? :"setsu-nord-vest" then  @fpr = 2 end
    if current_user.has_role? :"setsu-centru"    then  @fpr = 3 end
    if current_user.has_role? :"setsu-sud"       then  @fpr = 4 end
    if current_user.has_role? :"setsu"           then  @fpr = 5 end
    if current_user.has_role? :"cduser"          then  @fpr = 6 end
    if current_user.has_role? :"cduser-fee"      then  @fpr = 7 end
    if current_user.has_role? :"cduser-fenosa"   then  @fpr = 8 end
    @mp =  Mpoint.find(params[:id]) 
    @met = @mp.meters.order('relevance_date desc nulls last', created_at: :desc) 
    @met = @met.paginate(:page => params[:page], :per_page => @perpage = $PerPage)
  end

  def new
  end

  def create
    ddd=params[:koeftt].to_s
    ddd=ddd.scan(/[0-9]{1,}/)
    if ddd[0].nil? then kt1 = 1 else kt1 = ddd[0].to_i end
    if (ddd[1].nil? or ddd[1].to_i == 0) then kt2 = 1 else kt2 = ddd[1].to_i end    
    koeftt = kt1.to_s + " / " + kt2.to_s
    ddd=params[:koeftn].to_s
    ddd=ddd.scan(/[0-9]{1,}/)
    if ddd[0].nil? then kn1 = 1 else kn1 = ddd[0].to_i end
    if (ddd[1].nil? or ddd[1].to_i == 0) then kn2 = 1 else kn2 = ddd[1].to_i end     
    koeftn = kn1.to_s + " / " + kn2.to_s
    koefcalc = (kt1 * kn1) / (kt2 * kn2)     
    @mp =  Mpoint.find(params[:mpoint_id])
    @nmet= @mp.meters.new
    @nmet.metertype = params[:metertype]  
    @nmet.meternum = params[:meternum]  
    @nmet.koeftt = koeftt
    @nmet.koeftn = koeftn
    @nmet.koefcalc = koefcalc
    @nmet.relevance_date = params[:relevance_date]
    @nmet.comment = params[:comment]
    @nmet.save 
    redirect_to meters_index_path(:id => @mp.id)
  end

  def update
  end

  def show
    @met =  Meter.find(params[:id])
    @mp = @met.mpoint
    @mvs_all_pages = @met.mvalues.all.order(actdate: :desc, created_at: :desc, updated_at: :desc)        
    respond_to do |format|
      format.html
      format.pdf { send_data MpointsReport.new.to_pdf(@mvs_all_pages,@mp), :type => 'application/pdf', :filename => "history.pdf" }
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="history.xlsx"' }
    end       
  end
  
  def destroy
    met = Meter.find(params[:met_id])
    mp = Mpoint.find(met.mpoint_id)
    mv_count = met.mvalues.count
    if  mv_count!=0 then 
      flash[:warning] = "Нельзя удалить счетчик, которому принадлежат показания (#{mv_count} шт.)" 
    else met.destroy 
    end
    redirect_to meters_path(:id=>mp.id)
  end
  
end
