class ApiUser < ApplicationRecord
  belongs_to :customer    # foreign key naar de customer tabel

  has_secure_password     # ten behoeve van wachtwoord encryptie met bcrypt
end
