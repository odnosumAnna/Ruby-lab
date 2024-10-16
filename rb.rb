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
