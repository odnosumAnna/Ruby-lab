require 'benchmark'

class Report
  attr_reader :content

  def initialize(title)
    @content = "<html>\n<head>\n<title>#{title}</title>\n</head>\n<body>\n<h1>#{title}</h1>\n"
  end

  def add_paragraph(text)
    @content += "<p>#{text}</p>\n"
  end

  def add_table(data)
    @content += "<table border='1'>\n"
    data.each do |row|
      @content += "  <tr>\n"
      row.each { |cell| @content += "    <td>#{cell}</td>\n" }
      @content += "  </tr>\n"
    end
    @content += "</table>\n"
  end

  def to_html
    @content + "</body>\n</html>\n"
  end
end

# DSL Definition
class ReportDSL
  def initialize(title, &block)
    @report = Report.new(title)
    instance_eval(&block) if block_given?
  end

  def paragraph(text)
    @report.add_paragraph(text)
  end

  def table(data)
    @report.add_table(data)
  end

  def to_html
    @report.to_html
  end
end

# Usage Example
report = ReportDSL.new("Sample Report") do
  paragraph "This is the first paragraph of the report."
  paragraph "Here is another paragraph with some text."
  table [
          ["Header 1", "Header 2", "Header 3"],
          ["Row 1 Col 1", "Row 1 Col 2", "Row 1 Col 3"],
          ["Row 2 Col 1", "Row 2 Col 2", "Row 2 Col 3"]
        ]
end

puts report.to_html

time = Benchmark.measure do
  1000.times do
    ReportDSL.new("Benchmark Report") do
      paragraph "Benchmarking paragraph."
      table [
              ["Col 1", "Col 2", "Col 3"],
              ["Data 1", "Data 2", "Data 3"]
            ]
    end
  end
end

puts "Benchmarking 1000 reports generation: #{time.real} seconds"
