require "csv"

module CsvImportable
  extend ActiveSupport::Concern

  module ClassMethods
    def csv_import(file)
      # CSV から目的のモデルインスタンスを生成
      todos_with_lineno = parse(file)

      # バリデーションを実行
      errors = collect_validate_errors(todos_with_lineno)

      # エラーが無ければ bulk insert 実行
      # rubocop:disable Rails/SkipsModelValidations
      # `collect_validate_errors` にてバリデーション済みなので警告を抑制
      insert_all(todos_with_lineno.map(&:model)) if errors.empty?
      # rubocop:enable Rails/SkipsModelValidations

      errors
    end

    def collect_validate_errors(model_with_lineno)
      # 返却用配列
      errors = []

      # バリデーションを実行し、エラーがあればエラーメッセージを返却用配列へ格納
      model_with_lineno.each do |mwl|
        model = new(mwl.model)
        is_valid = model.validate

        messages = model.errors.full_messages.map do |message|
          "lineno: #{mwl.lineno}, name: #{mwl.model['name']}, message: #{message}"
        end

        errors.concat(messages) unless is_valid
      end

      errors
    end

    # CSV ファイルのパースを行い、Hash と行番号をセットにした配列を返却する
    #
    # ==== Args:
    # file(File)::CSVファイル
    #
    # ==== Return:
    # ModelWithLineno インスタンスの配列
    def parse(file)
      # 返却用配列
      models = []

      CSV.open(file.path, headers: true) do |csv|
        csv.each do |row|
          # key が header で、 value が CSV に記載された値となる Hash を生成
          values = csv.headers.to_h do |header, _index|
            [header, row[header]]
          end

          # 行番号とセットにして返却用配列へ格納
          models.append ModelWithLineno.new csv.lineno, values
        end
      end

      models
    end
  end

  class ModelWithLineno
    attr_accessor :lineno, :model

    def initialize(lineno, model)
      @lineno = lineno
      @model = model
    end
  end
end
