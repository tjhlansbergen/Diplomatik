class StudentQualification < ApplicationRecord
  belongs_to :student  
  belongs_to :qualification
end
