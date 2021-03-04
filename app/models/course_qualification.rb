# == Schema Information
#
# Table name: course_qualifications
#
#  course_id        :integer          not null
#  qualification_id :integer          not null
#
class CourseQualification < ApplicationRecord
  belongs_to :course  
  belongs_to :qualification
end
