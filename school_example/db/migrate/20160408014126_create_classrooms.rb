class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.integer :room_num, default: false
      t.boolean :lab_equip
      t.string :permalink

      t.timestamps null: false
    end
    add_index :classrooms, :permalink
  end
end
