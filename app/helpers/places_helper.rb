module PlacesHelper
    def room_full(place)
        return place.name
    end

    def free_spaces_count_class(places_count)
        ratio = places_count.free.to_f/places_count.all

        if ratio > 0.5 
            'success'
        elsif ratio > 0
            'warning'
        else 
            'danger'
        end
    end
end
