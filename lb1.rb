require 'benchmark'

class LongestCommonSubsequence
  def self.find_lcs(str1, str2)
    # Перевірка на типи вхідних даних
    raise ArgumentError, 'Параметри повинні бути рядками' unless str1.is_a?(String) && str2.is_a?(String)

    m = str1.length
    n = str2.length

    # Створення матриці для динамічного програмування
    lcs_matrix = Array.new(m + 1) { Array.new(n + 1, 0) }

    # Заповнення матриці
    (1..m).each do |i|
      (1..n).each do |j|
        if str1[i - 1] == str2[j - 1]
          lcs_matrix[i][j] = lcs_matrix[i - 1][j - 1] + 1
        else
          lcs_matrix[i][j] = [lcs_matrix[i - 1][j], lcs_matrix[i][j - 1]].max
        end
      end
    end

    # Відновлення найбільшої загальної підпослідовності
    lcs_string = ""
    i, j = m, n

    while i > 0 && j > 0
      if str1[i - 1] == str2[j - 1]
        lcs_string.prepend(str1[i - 1])
        i -= 1
        j -= 1
      elsif lcs_matrix[i - 1][j] >= lcs_matrix[i][j - 1]
        i -= 1
      else
        j -= 1
      end
    end

    return lcs_string
  end

  # Пошук LCS для декількох рядків
  def self.find_multi_lcs(*strings)
    # Перевірка на типи вхідних даних
    strings.each do |str|
      raise ArgumentError, 'Усі параметри повинні бути рядками' unless str.is_a?(String)
    end

    return '' if strings.empty?

    lcs_result = strings[0]
    strings[1..].each do |str|
      lcs_result = find_lcs(lcs_result, str)
    end

    lcs_result
  end
end

# Тести для LCS
require 'rspec'

RSpec.describe LongestCommonSubsequence do
  it "повинен знайти LCS для 'ABCD' і 'ACDF'" do
    sequence = LongestCommonSubsequence.find_lcs("ABCD", "ACDF")
    expect(sequence).to eq("ACD")
  end

  it "повинен знайти LCS для кількох рядків 'abcde', 'ace', 'acde'" do
    sequence = LongestCommonSubsequence.find_multi_lcs("abcde", "ace", "acde")
    expect(sequence).to eq("ace")
  end

  it "повинен знайти LCS для порожніх рядків" do
    sequence = LongestCommonSubsequence.find_lcs("", "")
    expect(sequence).to eq("")
  end

  it "повинен знайти LCS для 'ABC' і 'DEF'" do
    sequence = LongestCommonSubsequence.find_lcs("ABC", "DEF")
    expect(sequence).to eq("")
  end

  it "повинен знайти LCS для одного рядка" do
    sequence = LongestCommonSubsequence.find_multi_lcs("ABC")
    expect(sequence).to eq("ABC")
  end

  it "повинен викидати помилку, якщо параметри не рядки" do
    expect { LongestCommonSubsequence.find_lcs("ABCD", 123) }.to raise_error(ArgumentError, 'Параметри повинні бути рядками')
    expect { LongestCommonSubsequence.find_multi_lcs("abcde", "ace", 45) }.to raise_error(ArgumentError, 'Усі параметри повинні бути рядками')
  end
end

if __FILE__ == $0
  # Приклад використання
  puts "Приклад 1:"
  time_taken = Benchmark.measure {
    lcs_string = LongestCommonSubsequence.find_lcs("ABCD", "ACDF")
    puts "LCS: '#{lcs_string}'"
  }
  puts "Час виконання: #{time_taken.real} секунд"

  puts "\nПриклад 2:"
  time_taken = Benchmark.measure {
    lcs_string = LongestCommonSubsequence.find_lcs("AGGTAB", "GXTXAYB")
    puts "LCS: '#{lcs_string}'"
  }
  puts "Час виконання: #{time_taken.real} секунд"

  puts "\nПриклад 3:"
  time_taken = Benchmark.measure {
    lcs_string = LongestCommonSubsequence.find_multi_lcs("abcde", "ace", "acde")
    puts "LCS для кількох рядків: '#{lcs_string}'"
  }
  puts "Час виконання: #{time_taken.real} секунд"

  puts "\nПриклад 4:"
  time_taken = Benchmark.measure {
    lcs_string = LongestCommonSubsequence.find_lcs("ABC", "DEF")
    puts "LCS: '#{lcs_string}'"
  }
  puts "Час виконання: #{time_taken.real} секунд"

  puts "\nПриклад 5: Перевірка на один рядок"
  time_taken = Benchmark.measure {
    lcs_string = LongestCommonSubsequence.find_multi_lcs("ABC")
    puts "LCS для одного рядка: '#{lcs_string}'"
  }
  puts "Час виконання: #{time_taken.real} секунд"

  puts "\nПриклад 6:"
  # Приклад неправильних типів
  time_taken = Benchmark.measure {
    begin
      LongestCommonSubsequence.find_lcs("ABCD", 123)
    rescue ArgumentError => e
      puts "Помилка: #{e.message}"
    end
  }
  puts "Час виконання: #{time_taken.real} секунд"

  time_taken = Benchmark.measure {
    begin
      LongestCommonSubsequence.find_multi_lcs("abcde", "ace", 45)
    rescue ArgumentError => e
      puts "Помилка: #{e.message}"
    end
  }
  puts "Час виконання: #{time_taken.real} секунд"

  # Запуск тестів
  puts "\nЗапуск тестів"
  RSpec::Core::Runner.run([$__FILE__])
end
