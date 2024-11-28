class ReportDSL
  attr_accessor :title, :content

  def initialize
    @title = "Untitled Report"
    @content = []
  end

  def set_title(title)
    @title = title
  end

  def add_heading(text, level: 1)
    @content << "<h#{level}>#{text}</h#{level}>"
  end

  def add_paragraph(text)
    @content << "<p>#{text}</p>"
  end

  def add_table(headers, rows)
    table = "<table border='1'>"
    table << "<tr>" + headers.map { |header| "<th>#{header}</th>" }.join + "</tr>"
    rows.each do |row|
      table << "<tr>" + row.map { |cell| "<td>#{cell}</td>" }.join + "</tr>"
    end
    table << "</table>"
    @content << table
  end

  def generate_html
    <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>#{@title}</title>
      </head>
      <body>
        <h1>#{@title}</h1>
        #{@content.join("\n")}
      </body>
      </html>
    HTML
  end

  def save_to_file(file_name)
    File.write(file_name, generate_html)
    puts "Звіт збережено у файл: #{file_name}"
  end
end

def start_dialog
  report = ReportDSL.new

  puts "Ласкаво просимо до генератора HTML-звітів!"
  puts "Введіть назву звіту:"
  report.set_title(gets.chomp)

  loop do
    puts "\nЩо ви хочете додати?"
    puts "1. Заголовок"
    puts "2. Абзац"
    puts "3. Таблицю"
    puts "4. Завершити та зберегти звіт"
    print "Ваш вибір: "
    choice = gets.chomp.to_i

    case choice
    when 1
      print "Введіть текст заголовку: "
      text = gets.chomp
      print "Рівень заголовку (1-6): "
      level = gets.chomp.to_i
      level = 1 if level < 1 || level > 6
      report.add_heading(text, level: level)
    when 2
      print "Введіть текст абзацу: "
      text = gets.chomp
      report.add_paragraph(text)
    when 3
      print "Введіть заголовки таблиці через кому: "
      headers = gets.chomp.split(",").map(&:strip)
      rows = []
      loop do
        print "Введіть рядок таблиці (значення через кому) або залиште пустим для завершення: "
        row = gets.chomp
        break if row.empty?
        rows << row.split(",").map(&:strip)
      end
      report.add_table(headers, rows)
    when 4
      print "Введіть ім'я файлу для збереження звіту (з розширенням .html): "
      file_name = gets.chomp
      report.save_to_file(file_name)
      break
    else
      puts "Неправильний вибір. Спробуйте ще раз."
    end
  end
end

# Запуск програми
start_dialog
