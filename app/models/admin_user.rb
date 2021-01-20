class AdminUser < ApplicationRecord
    # ten behoeve van wachtwoord encryptie met bcrypt
    has_secure_password
end
