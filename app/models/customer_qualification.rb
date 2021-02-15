class CustomerQualification < ActiveRecord::Base 
  belongs_to :customer  
  belongs_to :qualification
end 