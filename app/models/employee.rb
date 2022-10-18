class Employee < ApplicationRecord

  belongs_to :company
  has_one_attached :image

  validates :name, presence: true, length: { maximum: 15 }
  validates :email, uniqueness: true
  validates :company_id, :last_name, :email, :address, :designation, :city, :mob_no, :salary, :technology, presence: true

end
