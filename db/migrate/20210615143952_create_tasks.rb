class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :introduction
      t.integer :required_time
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :tasks, [:user_id, :created_at]
  end
end
