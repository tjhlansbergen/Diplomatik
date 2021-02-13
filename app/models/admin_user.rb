# admin_user.rb - Tako Lansbergen 2020/01/25
# 
# Model voor een beheeraccount
# overerft van ApplicationRecord

class AdminUser < ApplicationRecord

    # databasevelden (worden impliciet als properties opgenomen):
    # username
    # password_digest (hashed)
    # created_at
    # updated_at

    # Valideer dat gebruikersnaam is ingevuld
    # Wachtwoord policy, minimaal 8 tekens
    # laat gebruikers het nieuwe wahtwoord tweemaal opgeven
    # valideer het huidige wachtwoord nogmaals bij wijzigen wachtwoord
    # valideer dat het nieuwe wacht anders is dan het huidige
    validates :username, presence: { message: "Geef een geldige gebruikersnaam op" }
    validates :username, uniqueness: { message: "Gebruikersnaam is al in gebruik" }
    validates :password, presence: { message: "Geef een geldig wachtwoord op" }, length: { minimum: 8, :message => "Wachtwoord is te kort (gebruik minimaal 8 tekens)" }
    validates_confirmation_of :password, :message => "De opgegeven wachtwoorden komen niet overeen"
    validate :current_password_is_correct, on: :update
    validate :new_password_is_different, on: :update
    
    has_secure_password     # ten behoeve van wachtwoord encryptie met bcrypt
    attr_accessor :current_password     # sta een form-veld voor huidig wachtwoord toe wat geen property van het model is

    # Verifieer huidig wachtwoord (bij wijigen wachtwoord)
    def current_password_is_correct
        if AdminUser.find(id).authenticate(current_password) == false
          errors.add(:current_password, "Huidig wachtwoord is onjuist")
        end
    end

    # verifieer of nieuw opgegeven wachtwoorden overeenkomen
    def new_password_is_different
        if current_password == password
            errors.add(:password, "Het nieuwe wachtwoord mag niet overeenkomen met het huidige wachtwoord")
        end
    end
    
end
