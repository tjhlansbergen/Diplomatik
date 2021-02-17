class CourseQualification < ApplicationRecord
  belongs_to :student  
  belongs_to :qualification
end
