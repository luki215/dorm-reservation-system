namespace :generators do
    namespace :kajka do 
        desc "Generate AppSettings for Kajetanka"
        task :app_settings => :environment do
            AppSetting.destroy_all
            AppSetting.create(is_running: false, dorm: :kajka)
        end
    end
end
