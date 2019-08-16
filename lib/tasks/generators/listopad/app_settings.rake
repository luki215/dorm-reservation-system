namespace :generators do
    namespace :listopad do 
        desc "Generate AppSettings for Listopad"
        task :app_settings => :environment do
            puts "destroying old appsettings"
            AppSetting.destroy_all
            puts "creating new appsettings"
            AppSetting.create(is_running: false, dorm: :listopad)
            puts "appsettings finished"
        end
    end
end
