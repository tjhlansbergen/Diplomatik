# log_entry.rb - Tako Lansbergen 2020/01/25
# 
# Model voor een logregel
# overerft van ApplicationRecord

# == Schema Information
#
# Table name: log_entries
#
#  id         :integer          not null, primary key
#  severity   :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin     :string
#

class LogEntry < ApplicationRecord
    # enum voor logregelniveau
    LEVEL = [INFORMATIONAL = 'informational', WARNING = 'warning', ERROR = 'error']
end
