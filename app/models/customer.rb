class Customer < ApplicationRecord
    validates :name, presence: { message: "Geef een geldige klantnaam op" }
end
