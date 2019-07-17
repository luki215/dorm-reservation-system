class Aliance < ApplicationRecord
  belongs_to :founder, class_name: :User
  has_many :users, dependent: :nullify
  has_many :alliance_membership_requests, dependent: :destroy
end
