class CreateTodoStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :todo_statuses do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :todo_statuses, [:name], unique: true
  end
end
