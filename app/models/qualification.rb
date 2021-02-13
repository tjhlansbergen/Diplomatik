class Qualification < ApplicationRecord
  belongs_to :qualification_type
  belongs_to :api_user

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :organization, presence: true
end
