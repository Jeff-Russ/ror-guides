class Course < ActiveRecord::Base
  belongs_to :teacher
  has_many :enrollments
  has_many :students, through: :enrollments
end
