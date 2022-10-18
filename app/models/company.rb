class Company < ApplicationRecord

  has_many :employees
  has_many :users
  has_one_attached :image

  validates :name, :address, :city, :state, :phone_no, :pin_code, :technologies, :link, :linkdin, :instagram, :facebook, presence: true
  
end
