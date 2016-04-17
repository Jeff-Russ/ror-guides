class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.references :course, index: true
      t.references :student, index: true
      
      t.timestamps
    end
    # add_index :enrollments, ["course_id", "student_id "]
  end
end	