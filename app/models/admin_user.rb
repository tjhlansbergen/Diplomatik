class AdminUser < ApplicationRecord
    has_secure_password     # ten behoeve van wachtwoord encryptie met bcrypt
end
