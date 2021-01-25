# log_entry.rb - Tako Lansbergen 2020/01/25
# 
# Model voor een logregel
# overerft van ApplicationRecord

class LogEntry < ApplicationRecord
    # enum voor logregelniveau
    LEVEL = [INFORMATIONAL = 'informational', WARNING = 'warning', ERROR = 'error']
end
