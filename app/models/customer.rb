class Customer < ApplicationRecord
    validates :name, presence: { message: "Geef een geldige klantnaam op" }
    has_many :api_users     # koppelt api_users aan de klant (SQL join)
end
