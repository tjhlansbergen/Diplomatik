# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string
#  deleted    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Customer < ApplicationRecord
    validates :name, presence: { message: "Geef een geldige klantnaam op" }
    has_many :api_users     # koppelt api_users aan de klant (SQL join)
    has_many :customer_qualifications
    has_many :customers, :through => :customer_qualifications
    has_many :courses
end
