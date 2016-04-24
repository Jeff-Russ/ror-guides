class DropCoursesStudentsJoin < ActiveRecord::Migration
  def change
    drop_table :courses_students
  end
end