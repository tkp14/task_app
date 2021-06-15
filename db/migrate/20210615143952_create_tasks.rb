class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.srting :name
      t.text :introduction
      t.integer :required_time

      t.timestamps
    end
  end
end
