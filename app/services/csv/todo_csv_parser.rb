module Csv
  class TodoCsvParser
    # Todo 用の CSV ファイルのパースを行い、Hash と行番号をセットにした配列を返却する
    #
    # ==== Args:
    # file(File)::Todo 用 CSV ファイル
    #
    # ==== Return:
    # CsvRecord インスタンスの配列
    def call(file)
      # 返却用配列
      models = []

      CSV.open(file.path, headers: true) do |csv|
        csv.each do |row|
          # key が header で、 value が CSV に記載された値となる Hash を生成
          values = csv.headers.to_h do |header, _index|
            [header, row[header]]
          end

          # 行番号とセットにして返却用配列へ格納
          models.append CsvRecord.new csv.lineno, values
        end
      end

      models
    end
  end
end
