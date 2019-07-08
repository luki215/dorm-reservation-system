class Place < ApplicationRecord
  belongs_to :user, optional: true

  def available?
    #TODO implement availability logic
    return self.user.nil?
  end
end
