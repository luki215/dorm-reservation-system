namespace :generators do
    desc "Generate everything for Kajetanka"
    task :kajka => :environment do 
        Rake::Task["generators:kajka:app_settings"].invoke
        Rake::Task["generators:kajka:rooms"].invoke
        Rake::Task["generators:users:users"].invoke
    end
end