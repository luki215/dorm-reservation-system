class SwitchRoom < ApplicationRecord
  belongs_to :user_requesting, class_name: :User
  belongs_to :user_requested, class_name: :User
end
