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
    @met = @mp.meters.paginate(:page => params[:page], :per_page => @perpage = 10)    
#    respond_to do |format|
#      format.html
#      format.csv { send_data @mv.to_csv }
#      format.xls { send_data @trp.to_csv(col_sep: "\t") }
#      format.pdf { send_data MpointsReport.new.to_pdf(@mv,@mp), :type => 'application/pdf', :filename => "history.pdf" }
#      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="history.xlsx"' }
#    end   
  end

  def new
    @mp =  Mpoint.find(params[:cnum]) 
  end

  def newcheck
    @mp =  Mpoint.find(params[:mpoint_id])
    @metertype = params[:metertype]
    @meternum = params[:meternum]
    ddd=params[:koeftt].to_s
    ddd=ddd.scan(/[0-9]{1,}/)
    if ddd[0].nil? then kt1 = 1 else kt1 = ddd[0].to_i end
    if (ddd[1].nil? or ddd[1].to_i == 0) then kt2 = 1 else kt2 = ddd[1].to_i end    
    @koeftt = kt1.to_s + " / " + kt2.to_s
    ddd=params[:koeftn].to_s
    ddd=ddd.scan(/[0-9]{1,}/)
    if ddd[0].nil? then kn1 = 1 else kn1 = ddd[0].to_i end
    if (ddd[1].nil? or ddd[1].to_i == 0) then kn2 = 1 else kn2 = ddd[1].to_i end     
    @koeftn = kn1.to_s + " / " + kn2.to_s
    kc = (kt1 * kn1) / (kt2 * kn2)  
    @koefcalc = kc    
  end

  def create
    @mp =  Mpoint.find(params[:mpoint_id])
    @nmet= @mp.meters.new
    @nmet.metertype = params[:metertype]
    @nmet.meternum = params[:meternum]
    ddd=params[:koeftt].to_s
    ddd=ddd.scan(/[0-9]{1,}/)
    if ddd[0].nil? then kt1 = 1 else kt1 = ddd[0].to_i end
    if (ddd[1].nil? or ddd[1].to_i == 0) then kt2 = 1 else kt2 = ddd[1].to_i end    
    @nmet.koeftt = kt1.to_s + " / " + kt2.to_s
    ddd=params[:koeftn].to_s
    ddd=ddd.scan(/[0-9]{1,}/)
    if ddd[0].nil? then kn1 = 1 else kn1 = ddd[0].to_i end
    if (ddd[1].nil? or ddd[1].to_i == 0) then kn2 = 1 else kn2 = ddd[1].to_i end     
    @nmet.koeftn = kn1.to_s + " / " + kn2.to_s
    kc = (kt1 * kn1) / (kt2 * kn2)  
    @nmet.koefcalc = kc
    @nmet.save 
    redirect_to meters_index_path(:id => @mp.id)
  end

  def update
  end

  def show
  end
end
