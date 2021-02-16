class Course < ApplicationRecord
  belongs_to :customer

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :customer
end
