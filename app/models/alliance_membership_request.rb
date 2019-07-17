class AllianceMembershipRequest < ApplicationRecord
  belongs_to :user
  belongs_to :aliance
end
