class Place < ApplicationRecord
  belongs_to :user, optional: true

  def available?
    #TODO implement availability logic
    return self.user.nil?
  end

  def self.places_count(building, floor = nil, cell = nil)
    places = self.where(building: building)
    places = places.where(floor: floor) if floor
    places = places.where(cell: cell) if cell

    Rails.cache.fetch(places.cache_key) do
      count = PlacesCount.new(places.where(user_id: nil).count, places.count)
      count
    end
  end
end

class PlacesCount
  attr_reader :free, :all

  def initialize(free, all)
    @free = free 
    @all = all
  end
end