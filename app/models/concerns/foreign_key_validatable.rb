module ForeignKeyValidatable
  extend ActiveSupport::Concern

  MUST_EXIST_IN_MASTER_ID = "activerecord.errors.messages.must_exist_in_master".freeze

  def must_exist_in_master(child_model_class, parent_model_class, key_id, attribute_symbol)
    is_valid = !parent_model_class.find_by(id: key_id).nil?

    unless is_valid
      errors.add(
        :base,
        validate_error_message_fo_must_exist_in_masterr(child_model_class, attribute_symbol, "[1, 2, 3]")
      )
    end

    is_valid
  end

  private

    def validate_error_message_fo_must_exist_in_masterr(child_model_class, attribute_symbol, enum_string)
      I18n.t(
        MUST_EXIST_IN_MASTER_ID,
        attribute: child_model_class.human_attribute_name(attribute_symbol),
        enum: enum_string
      )
    end
end
