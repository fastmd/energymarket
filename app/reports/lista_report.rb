# encoding: utf-8
class MpointsReport < Prawn::Document
  # ширина колонок
  Widths = [20, 100, 70, 70, 70, 70, 120]
  # заглавия колонок
  Headers = ["№", "Дата актирования", "1.8.0", "2.8.0", "3.8.0", "4.8.0", "Комментарий"]
  
  def row(d1, d2, d3, d4, d5, d6, d7)
    row = [d1, d2, d3, d4, d5, d6, d7]
    make_table([row]) do |t|
      t.column_widths = Widths
      t.cells.style :borders => [:left, :right], :padding => 2
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
      font "OpenSans", :size => 10
    else
      font_families.update( 
        "OpenSans" => {
                        :bold => "./app/assets/fonts/OpenSans-Bold.ttf",
                        :italic => "./app/assets/fonts/OpenSans-Italic.ttf",
                        :normal  => "./app/assets/fonts/OpenSans-Light.ttf" })
      font "OpenSans", :size => 10  
    end
    move_down(1)
    text "История показаний", :size => 15, :style => :bold, :align => :center
    move_down(18)
    text "Наименование поставщика:  #{mpoints.company.furnizor.name}", :size => 12, :style => :bold, :align => :left     
    text "Наименование потребителя: #{mpoints.company.name}", :size => 12, :style => :bold, :align => :left
    text "Подстанция МЭ: #{mpoints.messtation}", :size => 12, :style => :bold, :align => :left 
    text "Присоединение МЭ: #{mpoints.meconname}", :size => 12, :style => :bold, :align => :left 
    text "Подстанция потребителя: #{mpoints.clsstation}", :size => 12, :style => :bold, :align => :left 
    text "Присоединение потребителя: #{mpoints.clconname}", :size => 12, :style => :bold, :align => :left
    move_down(28)  
    # выборка записей
    i=0      
    data = []
    if !mvalues.nil? then
    items = mvalues.each do |item|
      data << row(i+=1, item.actdate.to_formatted_s(:day_month_year), item.actp180, item.actp280, item.actp380, item.actp480, item.comment)
    end
    end
    
    head = make_table([Headers], :column_widths => Widths)
    table([[head], *(data.map{|d| [d]})], :header => true, :row_colors => %w[cccccc ffffff]) do
      row(0).style(:background_color => 'ffffff', :text_color => '000000', :font_style => :bold, :align => :center)
      cells.style :borders => [:left, :right]
      row(0).borders = [:top, :bottom, :left, :right]
     # row(1..50).borders = [:left, :right]
      row(-1).borders = [:bottom, :left, :right]
    end
     # добавим время создания вверху страницы
    creation_date = Time.now.strftime("Отчет сгенерирован %e %b %Y в %H:%M")
    go_to_page(page_count)
    move_down(0)
    text creation_date, :align => :right, :style => :italic, :size => 9   
    render
  end
  
end