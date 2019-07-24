json.extract! app_setting, :id, :first_round_start, :second_round_start, :third_round_start, :fourth_round_start, :is_running, :created_at, :updated_at
json.url app_setting_url(app_setting, format: :json)
