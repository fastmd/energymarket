# encoding: utf-8
class ListaReport < Prawn::Document
  # ширина колонок
  Widths = [20, 100, 70, 50, 50, 50, 50, 50, 50, 50]
      # заглавия колонок
  Headers = ["№", "RRE,SE si liniilor", "Punctul de evidenta", "", "№ contor.", "Indicatii", 
             "Indicatii", "Diferenta indicat.", "Coeficient contor.", "Energie kWh"]
               
  def row(d1, d2, d3, d4, d5, d6, d7, d8, d9, d10)
    row = [d1, d2, d3, d4, d5, d6, d7, d8, d9, d10]
    make_table([row]) do |t|
      t.column_widths = Widths
      t.cells.style :borders => [:left, :right], :padding => 2
    end
  end
    
  def to_pdf(cp,report,luna,ddate,luna_e,luna_b)
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
     # добавим время создания вверху страницы
    creation_date = Time.now.strftime("Отчет сгенерирован %e %b %Y в %H:%M")
    move_down(0)
    text creation_date, :align => :right, :style => :italic, :size => 9  
    move_down(1)
    text "LISTA", :size => 15, :style => :bold, :align => :center
    text "de calcul a intrarii energiei electrice la #{cp.name}", :size => 14, :style => :bold, :align => :center
    text "pentru luna #{luna} anul #{ddate.year}", :size => 15, :style => :bold, :align => :center
    move_down(18) 
    text "#{flr.name}", :size => 12, :style => :bold, :align => :left 
    move_down(10)  
    # выборка записей 
    data = []
    if !report.nil? then
      items = report.each do |item|
        data << row(item[0], item[1], item[2], item[3], item[4], item[5], item[6], item[7], item[8], item[9])
      end 
    end
    Headers[5] = "Indicatii \n #{luna_e}"
    Headers[6] = "Indicatii \n #{luna_b}"
    head = make_table([Headers], :column_widths => Widths)
    table([[head], *(data.map{|d| [d]})], :header => true, :row_colors => %w[cccccc ffffff]) do
      row(0).style(:background_color => 'ffffff', :text_color => '000000', :font_style => :bold, :align => :center)
      cells.style :borders => [:left, :right]
      row(0).borders = [:top, :bottom, :left, :right]
     # row(1..50).borders = [:left, :right]
      row(-1).borders = [:bottom, :left, :right]
    end 
    render
  end
  
end