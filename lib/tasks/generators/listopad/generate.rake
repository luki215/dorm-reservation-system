namespace :generators do
    desc "Generate everything for Listopad"
    task :listopad => :environment do 
        Rake::Task["generators:listopad:app_settings"].invoke
        Rake::Task["generators:listopad:rooms"].invoke
        Rake::Task["generators:listopad:users"].invoke
    end
end