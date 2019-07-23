class Place < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :primary_claim, class_name: :User, optional: true
  belongs_to :secondary_claim, class_name: :User, optional: true

  scope :places_not_colliding_with_restriction, ->(current_user) do 
    # no place on same cell/room with user having same sex as in parameter
    query = "NOT EXISTS (
      SELECT 1 AS one
      FROM places as inner_places INNER JOIN users ON users.id = inner_places.user_id 
      WHERE   places.id != inner_places.id "
    query += " AND users.male != ?"
    query += " AND places.cell = inner_places.cell" if current_user.same_sex_cell
    query += " AND places.cell = inner_places.cell AND places.room = inner_places.room" if !current_user.same_sex_cell && current_user.same_sex_room
    query += ")"

    # no place on same cell/room with user having same sex as in parameter
    query_not_collide_with_existing_reservations = "NOT EXISTS(
      SELECT 1 AS one
      FROM places as inner_places INNER JOIN users on users.id = inner_places.user_id
      WHERE users.male != ? AND (
            (users.same_sex_cell AND inner_places.cell = places.cell) OR
            (users.same_sex_room AND places.cell = inner_places.cell AND places.room = inner_places.room)
          )
    )"
    res = where(query_not_collide_with_existing_reservations, current_user.male)
    res = res.where(query, current_user.male) if current_user.same_sex_cell || current_user.same_sex_room
    res
  end

  scope :available, -> (current_user) do
    where(user_id: nil).places_not_colliding_with_restriction(current_user)
  end

  def available?(current_user)
    return self.user.nil? ? Place.available(current_user).exists?(id: self.id) : false
  end

  def availability_status(current_user)
    return :unavailable_reserved if !self.user.nil?
    return :unavailable_different_sex if !self.available?(current_user)
    return :available
  end

  def self.places_count(current_user, building, floor = nil, cell = nil)
    places = self.where(building: building)
    places = places.where(floor: floor) if floor
    places = places.where(cell: cell) if cell
    Rails.cache.fetch(places.available(current_user).cache_key) do
      count = PlacesCount.new(places.available(current_user).count, places.count)
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