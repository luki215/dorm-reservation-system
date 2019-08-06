json.extract! switch_room, :id, :user_requesting_id, :user_requested_id, :created_at, :updated_at
json.url switch_room_url(switch_room, format: :json)
