class Place < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :primary_claim, class_name: :User, optional: true
  belongs_to :secondary_claim, class_name: :User, optional: true

  validate :sex_validation, :room_type_validation, :round_validation

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
    return self.user.nil? ? self.room_type == current_user.room_type && Place.available(current_user).exists?(id: self.id) : false
  end

  def availability_status(current_user)
    return :unavailable_reserved if !self.user.nil?
    return :unavailable_wrong_type if self.room_type != current_user.room_type
    return :unavailable_different_sex if !self.available?(current_user)
    return :available
  end

  def places_on_same_room
    return Place.where(building: self.building, floor: self.floor, room: self.room).preload(:user)
  end

  def places_on_same_cell
    return Place.where(building: self.building, floor: self.floor, cell: self.cell).preload(:user)
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


  def name 
    return self.building + self.floor.to_s + self.room + "#" + self.bed
  end

  
  def room_name 
    return self.building + self.floor.to_s + self.room
  end

  def correct_round?(current_user)
    if AppSetting.first.current_round == :fourth
       return true
    elsif  current_user.secondary_claim && AppSetting.first.current_round_numeric > 1 && current_user.secondary_claim.room_name == self.room_name
       return true
    elsif  current_user.primary_claim && AppSetting.first.current_round_numeric > 0 && current_user.primary_claim.room_name == self.room_name
       return true
    else
       return false
    end 
  end

  private 
  def sex_validation
    if self.user 
      res = 
      # not violating mine preferences
      (!self.user.same_sex_cell || places_on_same_cell.all? {|place| place.user.nil? || place.user.male == self.user.male}) &&
      (!self.user.same_sex_room || places_on_same_room.all? {|place| place.user.nil? || place.user.male == self.user.male}) &&
      # not violationg others preferences
      places_on_same_cell.all? {|place| place.user.nil? || !place.user.same_sex_cell || place.user.male == self.user.male } &&
      places_on_same_room.all? {|place| place.user.nil? || !place.user.same_sex_room || place.user.male == self.user.male }
      
      self.errors.add(:sex, "Sex mismatch") unless res
      res
    else 
      true
    end
  end

  def round_validation

    if !self.user.nil? && !self.correct_round?(self.users)
      self.errors.add(:round, "You have not right to reserve this room in this round")
      return false
    else
      true
    end
  end

  def room_type_validation
  end

end

class PlacesCount
  attr_reader :free, :all

  def initialize(free, all)
    @free = free 
    @all = all
  end
end
