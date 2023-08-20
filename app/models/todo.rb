class Todo < ApplicationRecord
  include CsvImportable

  def self.ransackable_attributes(_auth_object = nil)
    %w[name todo_status_id id created_at updated_at]
  end

  belongs_to :todo_status, optional: true
  validates :name, presence: true
  validates :todo_status_id, presence: true
  validates_with ForeignKeyValidator,
                 child_model_class: Todo,
                 child_attribute_symbol: :todo_status_id,
                 parent_model_class: TodoStatus,
                 enum_string: TodoStatus.all.map(&:id)
end
