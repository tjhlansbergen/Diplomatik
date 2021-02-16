class CourseQualification < ApplicationRecord
  belongs_to :course  
  belongs_to :qualification
end
