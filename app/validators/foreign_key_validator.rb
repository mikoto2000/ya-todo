# 外部キーで設定した値が存在しているかを検証するバリデーター
#
# ==== オプション:
# - child_model_class:: 子エンティティのクラスオブジェクト
# - child_attribute_symbol:: 子エンティティのフィールド名(カラム名)
# - parent_model_class:: 親エンティティのクラスオブジェクト
# - enum_string:: 取りうる値を表現する文字列
#
# ==== Example:
#     # Todo が belongs_to で :todo_status パラメーターを TodoStatus へ外部キー設定を行っている
#     validates_with ForeignKeyValidator,
#                    child_model_class: Todo,
#                    child_attribute_symbol: :todo_status_id,
#                    parent_model_class: TodoStatus,
#                    enum_string: TodoStatus.all.map(&:id)
class ForeignKeyValidator < ActiveModel::Validator
  MUST_EXIST_IN_MASTER_ID = "activerecord.errors.messages.must_exist_in_master".freeze

  # 外部キーで設定した値が存在しているかを検証する
  #
  # オプション:
  # - child_model_class:: 子エンティティのクラスオブジェクト
  # - child_attribute_symbol:: 子エンティティのフィールド名(カラム名)
  # - parent_model_class:: 親エンティティのクラスオブジェクト
  # - enum_string:: 取りうる値を表現する文字列
  def validate(record)
    # 指定した値が親エンティティに存在するか確認
    is_valid = exists_in_parent?(record, options[:parent_model_class], options[:child_attribute_symbol])

    # 存在しなければ、エラーメッセージを作成し、追加
    unless is_valid
      record.errors.add(
        :base,
        error_message(options[:child_model_class],
                      options[:child_attribute_symbol],
                      options[:enum_string])
      )
    end

    is_valid
  end

  private

    # 指定した値が親エンティティに存在するか確認
    def exists_in_parent?(record, parent_model_class, child_attribute_symbol)
      !parent_model_class.find_by(id: record[child_attribute_symbol]).nil?
    end

    # エラーメッセージ組み立て
    def error_message(child_model_class, attribute_symbol, enum_string)
      I18n.t(
        MUST_EXIST_IN_MASTER_ID,
        attribute: child_model_class.human_attribute_name(attribute_symbol),
        enum: enum_string
      )
    end
end
