class AddGradesToEnrollments < ActiveRecord::Migration
  def change
    add_column :enrollments, :grade, :decimal, precision: 5, scale: 2
    add_column :enrollments, :elective, :boolean, default: false
  end
end
