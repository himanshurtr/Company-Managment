class User < ApplicationRecord
  rolify

  belongs_to :company, optional: true
  has_one_attached :image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  validate :must_have_a_role, on: [:update, :create]


  def admin?
    self.has_role? :admin
  end

  def internal_admin?
    self.has_role? :superadmin
  end

  def com_admin?
    self.has_role? :company_admin
  end

private

  after_create :assign_default_role

  # scope :internal_admins -> { where(company_id: nil, roles: {name: 'admin'}) }


  def assign_default_role
   self.add_role(:newuser) if self.roles.blank?
  end

  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "must have atleast 1 role")
    end
  end 

end
