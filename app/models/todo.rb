class Todo < ApplicationRecord
  include CsvImportable
  include ForeignKeyValidatable

  def self.ransackable_attributes(_auth_object = nil)
    %w[name todo_status_id id created_at updated_at]
  end

  belongs_to :todo_status, optional: true
  validates :name, presence: true
  validates :todo_status_id, presence: true
  validate :todo_status_must_exist_in_master

  def todo_status_must_exist_in_master
    must_exist_in_master(Todo, TodoStatus, todo_status_id, :todo_status_id)
  end
end
