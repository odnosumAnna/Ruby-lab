require 'minitest/autorun'
require_relative 'report_dsl'

class ReportDSLTest < Minitest::Test
  def test_paragraph_addition
    report = ReportDSL.new("Test Report") do
      paragraph "This is a test paragraph."
    end
    assert_includes report.to_html, "<p>This is a test paragraph.</p>"
  end

  def test_table_addition
    report = ReportDSL.new("Test Report") do
      table [["Header1", "Header2"], ["Row1Col1", "Row1Col2"]]
    end
    assert_includes report.to_html, "<td>Row1Col1</td>"
  end

  def test_html_structure
    report = ReportDSL.new("Test Report") {}
    assert_match /<html>.*<\/html>/m, report.to_html
  end
end