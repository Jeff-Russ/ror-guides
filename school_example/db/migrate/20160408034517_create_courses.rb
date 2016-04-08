class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.references :teacher, index: true, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
