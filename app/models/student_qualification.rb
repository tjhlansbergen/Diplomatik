# == Schema Information
#
# Table name: student_qualifications
#
#  student_id       :integer          not null
#  qualification_id :integer          not null
#
class StudentQualification < ApplicationRecord
  belongs_to :student  
  belongs_to :qualification
end
