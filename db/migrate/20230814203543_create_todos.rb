class CreateTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :todos, [:name], unique: true
  end
end
