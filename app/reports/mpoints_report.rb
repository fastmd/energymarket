# encoding: utf-8
class MpointsReport < Prawn::Document
  # ширина колонок
  Widths = [25, 60, 60, 60, 60, 60, 60, 140]
  # заглавия колонок
  Headers = ["№", "Дата актирования","№ счетчика", "1.8.0", "2.8.0", "3.8.0", "4.8.0", "Комментарий"]
  
  def row(d1, d2, d3, d4, d5, d6, d7, d8)
    row = [d1, d2, d3, d4, d5, d6, d7, d8]
    make_table([row]) do |t|
      t.column_widths = Widths
      t.cells.style :borders => [:left, :right], :padding => 2, :font_style => :normal, :font_size => 8
    end
  end
    
  def to_pdf(mvalues,mpoints)
    # привязываем шрифты
    if RUBY_PLATFORM == "i386-mingw32" then
      font_families.update(
        "OpenSans" => {
                        :bold => "./app/assets/fonts/OpenSans-Bold.ttf",
                        :italic => "./app/assets/fonts/OpenSans-Italic.ttf",
                        :normal  => "./app/assets/fonts/OpenSans-Light.ttf" })
      font "OpenSans", :size => 8
    else
      font_families.update( 
        "OpenSans" => {
                        :bold => "./app/assets/fonts/OpenSans-Bold.ttf",
                        :italic => "./app/assets/fonts/OpenSans-Italic.ttf",
                        :normal  => "./app/assets/fonts/OpenSans-Light.ttf" })
      font "OpenSans", :size => 8  
    end
    move_down(1)
    text "История показаний", :size => 15, :style => :bold, :align => :center
    move_down(18)
    text "Поставщик:  #{mpoints.furnizor.name}", :size => 12, :style => :bold, :align => :left     
    text "Потребитель: #{mpoints.company.name}", :size => 12, :style => :bold, :align => :left
    text "Филиал: #{mpoints.mesubstation.filial.name}", :size => 12, :style => :bold, :align => :left
    text "Регион: #{mpoints.mesubstation.region.cvalue}", :size => 12, :style => :bold, :align => :left
    text "Подстанция (подключен потребитель): #{mpoints.mesubstation.name}", :size => 12, :style => :bold, :align => :left 
    text "Присоединение (запитан потребитель): #{mpoints.meconname}", :size => 12, :style => :bold, :align => :left 
    text "Объект установки учета: #{mpoints.clsstation}", :size => 12, :style => :bold, :align => :left 
    text "Присоединение установки учета: #{mpoints.clconname}", :size => 12, :style => :bold, :align => :left
    move_down(28)  
    # выборка записей
    i=0      
    data = []
    if !mvalues.nil? then
    items = mvalues.each do |item|
      data << row(i+=1, item.actdate.to_formatted_s(:day_month_year),item.meter.meternum,item.actp180, item.actp280, item.actp380, item.actp480, item.comment)
    end
    end
    
    head = make_table([Headers], :column_widths => Widths)
    table([[head], *(data.map{|d| [d]})], :header => true, :row_colors => %w[cccccc ffffff]) do
      row(0).style(:background_color => 'ffffff', :text_color => '000000', :font => [:style => :normal, :size => 8], :align => :center)
      cells.style(:borders => [:left, :right], :font => [:style => :normal, :size => 8])
      row(0).borders = [:top, :bottom, :left, :right]
     # row(1..50).borders = [:left, :right]
      row(-1).borders = [:bottom, :left, :right]
    end
     # добавим время создания вверху страницы
    creation_date = Time.now.strftime("Отчет сгенерирован %e %b %Y в %H:%M")
    go_to_page(page_count)
    move_down(0)
    text creation_date, :align => :right, :style => :italic, :size => 8   
    render
  end
  
end