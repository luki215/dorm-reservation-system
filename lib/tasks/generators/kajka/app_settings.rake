namespace :generators do
    namespace :kajka do 
        desc "Generate AppSettings for Kajetanka"
        task :app_settings => :environment do
            AppSetting.destroy_all
            AppSetting.create(
                is_running: false, 
                dorm: :kajka, 
                first_round_start: Time.now,
                second_round_start: Time.now,
                third_round_start: Time.now,
                fourth_round_start: Time.now
            )
        end
    end
end
