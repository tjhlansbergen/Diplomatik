# api_user.rb - Tako Lansbergen 2020/01/26
# 
# Model voor een App account
# overerft van ApplicationRecord

# == Schema Information
#
# Table name: api_users
#
#  id              :integer          not null, primary key
#  username        :string
#  password_digest :string
#  customer_id     :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  can_add_users   :boolean
#

class ApiUser < ApplicationRecord
  belongs_to :customer    # foreign key naar de customer tabel

  validates :username, presence: { message: "Geef een geldige gebruikersnaam op" }
  validates :username, uniqueness: { message: "Gebruikersnaam is al in gebruik" }
  validates :password, presence: { message: "Geef een geldig wachtwoord op" }, length: { minimum: 8, :message => "Wachtwoord is te kort (gebruik minimaal 8 tekens)" }
  validates_confirmation_of :password, :message => "De opgegeven wachtwoorden komen niet overeen"

  has_secure_password     # ten behoeve van wachtwoord encryptie met bcrypt
  attr_accessor :current_password     # sta een form-veld voor huidig wachtwoord toe wat geen property van het model is
end
