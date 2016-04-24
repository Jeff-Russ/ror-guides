class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.integer :room_num
      t.boolean :lab_equip, default: false

      t.timestamps null: false
    end
  end
end
