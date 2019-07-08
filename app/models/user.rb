class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable :registerable, :recoverable
  devise :database_authenticatable, :rememberable, :validatable
  scope :students, -> { where(:admin => false) }

  has_one :place
end
