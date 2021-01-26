# api_user.rb - Tako Lansbergen 2020/01/26
# 
# Model voor een API account
# overerft van ApplicationRecord

class ApiUser < ApplicationRecord
  belongs_to :customer    # foreign key naar de customer tabel

  has_secure_password     # ten behoeve van wachtwoord encryptie met bcrypt
end
