# == Schema Information
#
# Table name: customer_qualifications
#
#  customer_id      :integer          not null
#  qualification_id :integer          not null
#
class CustomerQualification < ActiveRecord::Base 
  belongs_to :customer  
  belongs_to :qualification
end 
