module PlacesHelper
    def room_full(place)
        return place.building + place.floor.to_s + place.room
    end
end
