class Customer < ApplicationRecord
    validates :name, presence: { message: "Geef een geldige klantnaam op" }
    has_many :api_users     # koppelt api_users aan de klant (SQL join)
    has_many :customer_qualifications
    has_many :customers, :through => :customer_qualifications
end
