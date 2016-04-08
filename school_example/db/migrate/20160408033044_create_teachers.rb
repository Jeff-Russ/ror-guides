class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.references :classroom, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
  end
end
