class Place < ApplicationRecord
  belongs_to :user, optional: true
end
