class MinputsController < ApplicationController
before_action :check_user  
before_filter :redirect_cancel, only: [:create, :update]
  
  def show
    redirect_to minputs_index_path(:page => params[:page])
  end

  def index
    @flag = params[:flag]     
    indexviewall
    calcpage     
    #render inline: "<%= @minput.inspect %><br><br><%= @minputs.inspect %><br><br><%= @mp.inspect %><br><br><br><br>" and return
  end
  
  def create  
    @flag = 'add'
    minput_save
    #render inline: "<%= params.inspect %><br><br>" and return    
  end
  
  def update
    @flag = 'edit' 
    minput_save    
  end
  
  def new
   #render inline: "<%= params.inspect %><br><br>" and return   
  end
  
  def edit
    flash.discard 
    redirect_to minputs_index_path(:flag => 'edit',:id => params[:id], :mpoint_id => params[:mpoint_id], :page => params[:page])     
  end
  
  def destroy
    minput = Minput.find(params[:id])
    minput.destroy 
    redirect_to minputs_index_path(:page => params[:page], :mpoint_id => params[:mpoint_id])
  end   
  
private
  
  def indexviewall 
    @mp =  Mpoint.find(params[:mpoint_id])
    if @fpr < 6 then  @flr =  @mp.mesubstation.filial else @flr =  @mp.furnizor end
    @minputs = @mp.minputs.all.order(mdate: :desc)  
    if (!params[:id].nil? and params[:id]!='') then @minput=Minput.find(params[:id]) else @minput = @mp.minputs.build end
  end
  
  def calcpage    
    #---page----------------------
    if (params.has_key?(:page)) then @page = params[:page] end
    if !@minput.nil? && !@minput.id.nil? then 
      i = 0
      n = 0
      @minputs.each do |item|
        if item.id == @minput.id then n = i end
        i += 1   
      end
      @page = (n / $PerPage + 0.5).round       
    end  
    if @page.nil? then 
      @page = 1
    elsif !@minputs.nil? &&  @minputs.count < (@page.to_i - 1) * $PerPage then 
      @page = ((@minputs.count-1) / $PerPage + 0.5).round    
    end  
    unless @minputs.nil? then @minputs = @minputs.paginate(:page => @page, :per_page => $PerPage ) end     
  end

  def minput_save
    indexviewall
    @minput.tplosses = params[:tplosses]
    @minput.trlosses = params[:trlosses]
    @minput.llosses = params[:llosses]
    @minput.cti = params[:cti]
    @minput.ctc = params[:ctc]
    @minput.mdate = params[:mdate]
    @minput.comment = params[:comment]
    @minput.f = if params[:f].nil? then false else true end
    if @minput.mdate.nil? then 
        flash[:warning] = "Дата не может быть пустой. Проверьте правильность ввода." 
        calcpage       
        render 'index'     
    else   
      if Minput.any? then t = Minput.where("mdate = ?", @minput.mdate).count else t = 0 end
      if (t != 0) and (@minput.id.nil?)  then
        flash[:warning] = "Объект за #{@minput.mdate.to_formatted_s(:day_month_year)} уже существует. Проверьте правильность ввода."
        calcpage       
        render 'index'      
      else
        begin
          if @minput.save! then 
            #@flag = nil
            flash.discard
            flash[:notice] = "Объект за #{@minput.mdate.to_formatted_s(:day_month_year)} сохранен." 
            #@minput = Minput.new
            @minputs = @mp.minputs.all.order(mdate: :desc) 
            calcpage
            #render inline: "<%= params.inspect %><br><br><%= @page.inspect %><br><br>" and return  
            redirect_to minputs_index_path(:mpoint_id => params[:mpoint_id], :page => @page) 
          end
        rescue
          #render inline: "<%= params.inspect %><br><br><%= @minput.inspect %><br><br>" and return 
          calcpage
          flash[:warning] = "Данные не сохранены. Проверьте правильность ввода."       
          render 'index'
        end
      end
    end      
  end

  def redirect_cancel
    redirect_to minputs_index_path(:mpoint_id => params[:mpoint_id], :flag => nil, :page => params[:page]) if params[:cancel]
  end
      
end
