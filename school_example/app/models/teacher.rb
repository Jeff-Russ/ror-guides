class Teacher < ActiveRecord::Base
	belongs_to :classroom
	has_many :courses
end
