class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :classroom_id
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
    add_index :teachers, :classroom_id
  end
end
