# application_record.rb - Tako Lansbergen 2020/01/25
# 
# Base-klasse voor de MVC modellen
# overerft ACtiveRecord (abstract)

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
