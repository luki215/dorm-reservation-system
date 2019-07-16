class Aliance < ApplicationRecord
  belongs_to :founder, class_name: :User
  has_many :users
end
