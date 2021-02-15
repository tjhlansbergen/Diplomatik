class Qualification < ApplicationRecord
  belongs_to :qualification_type
  has_many :customer_qualifications
  has_many :customers, :through => :customer_qualifications

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :organization
  validates :organization, presence: true
end
