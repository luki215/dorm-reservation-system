json.extract! user, :id, :fullname, :male, :same_sex_room, :same_sex_cell, :note, :created_at, :updated_at
json.url user_url(user, format: :json)
