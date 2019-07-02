json.extract! user, :id, :fullname, :allow_alliance, :allow_room_switch, :move_with_alliance, :male, :same_sex_room, :same_sex_cell, :allow_share_info, :note, :created_at, :updated_at
json.url user_url(user, format: :json)
