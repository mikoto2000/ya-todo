class Todo < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[name todo_status_id id created_at updated_at]
  end

  belongs_to :todo_status
  validates :name, presence: true
end
