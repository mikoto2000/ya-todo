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
    # CSV のヘッダー名: {
    #   parent: 親エンティティのクラスオブジェクト,
    #   search_column_name: find_by で探すカラム名
    # }
    ASSOCIATION_CONFIG = {
      CSV_HEADER_STATUS => {
        parent: TodoStatus,
        search_column_name: :name
      }
    }.freeze

    def initialize(logger = Rails.logger)
      @logger = logger
    end

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
        @logger.debug(self.class.name) { "start parse_row { row: #{row} }" }

        csv.headers.to_h do |csv_header, _index|
          striped_csv_header = csv_header.strip
          column_name = convert_header(striped_csv_header)
          value = convert_value(striped_csv_header, row[csv_header].strip)
          [column_name, value]
        end
      end

      def convert_header(header)
        @logger.debug(self.class.name) { "convert header: { origin: #{header}, converted #{HEADER_CONFIG[header]} }" }
        HEADER_CONFIG[header]
      end

      # CSV に記載された値を、各列毎に指定された条件に応じて変換する
      #
      # ==== Args:
      # header::検索に使用するエンティティのクラスオブジェクト
      # value::検索に使用するカラム名
      #
      # ==== Return:
      # id が見つかった場合は id を返却、見つからなかった場合は value をそのまま返却
      def convert_value(header, value)
        converted_value =
          if ASSOCIATION_CONFIG.key? header
            get_id_by_value(ASSOCIATION_CONFIG[header][:parent], ASSOCIATION_CONFIG[header][:search_column_name], value)
          else
            value
          end

        @logger.debug(self.class.name) { "convert value: { origin: #{value}, converted #{converted_value} }" }

        converted_value
      end

      # 値を基に関連付けられた外部キーの id を取得する
      #
      # ==== Args:
      # parent_model_class::検索に使用するエンティティのクラスオブジェクト
      # search_column_name::検索に使用するカラム名
      # value::検索に使用する値
      #
      # ==== Return:
      # id が見つかった場合は id を返却、見つからなかった場合は value をそのまま返却
      def get_id_by_value(parent_model_class, search_column_name, value)
        entity = parent_model_class.find_by(search_column_name => value)
        if entity.nil?
          value
        else
          entity.id
        end
      end
  end
end
