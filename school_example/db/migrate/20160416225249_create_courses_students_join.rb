class CreateCoursesStudentsJoin < ActiveRecord::Migration

  def change
    create_table( :courses_students, id: false ) do |t|
      t.integer "course_id"
      t.integer "student_id"
    end
    add_index( :courses_students, ["course_id", "student_id"])
  end

end