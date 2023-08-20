module Csv
  class TodoCsvParser
    CSV_HEADER_NAME = "name".freeze
    CSV_HEADER_STATUS = "状態".freeze

    TABLE_COLUMN_NAME = "name".freeze
    TABLE_COLUMN_STATUS = "todo_status_id".freeze

    # ヘッダーの変換ルールを定義した Hash
    #
    # key: CSV のヘッダー名
    # value: テーブルのカラム名
    HEADER_CONFIG = {
      CSV_HEADER_NAME => TABLE_COLUMN_NAME,
      CSV_HEADER_STATUS => TABLE_COLUMN_STATUS
    }.freeze

    # 外部キーの紐づけを定義した Hash
    #
    # 構造は以下の通り
    # テーブルカラム名: {
    #   parent: 親エンティティのクラスオブジェクト,
    #   search_column_name: find_by で探すカラム名
    # }
    ASSOCIATION_CONFIG = {
      TABLE_COLUMN_STATUS => {
        parent: TodoStatus,
        search_column_name: :name
      }
    }.freeze

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
          # 行をパース
          model = parse_row(csv, row)

          # 行番号とセットにして返却用配列へ格納
          models.append CsvRecord.new csv.lineno, model
        end
      end

      models
    end

    private

      # key が header で、 value が CSV に記載された値となる Hash を生成
      def parse_row(csv, row)
        csv.headers.to_h do |csv_header, _index|
          striped_csv_header = csv_header.strip
          column_name = convert_header(striped_csv_header)
          value = convert_value(column_name, row[csv_header].strip)
          [column_name, value]
        end
      end

      def convert_header(header)
        HEADER_CONFIG[header]
      end

      def convert_value(header, value)
        if ASSOCIATION_CONFIG.key? header
          entity = ASSOCIATION_CONFIG[header][:parent].find_by(ASSOCIATION_CONFIG[header][:search_column_name] => value)
          if entity.nil?
            value
          else
            entity.id
          end
        else
          value
        end
      end
  end
end
