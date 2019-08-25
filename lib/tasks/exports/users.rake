require 'csv'
namespace :exports do
    desc "Export users"
    task :users => :environment do
        puts "Exporting users...."
        CSV.open("tmp/export.csv", "wb") do |csv|
            csv << ["Name", "Mail", "Primary claim", "Secondaty claim", "Admin claim", "Room", "Alliance name" ]
            User.all.each do |user|
                csv << [user.fullname,  user.email, user.primary_claim&.room_name, 
                        user.secondary_claim&.room_name, user.admin_claim&.room_name,
                        user.place&.room_name, user.aliance&.name
                        ]
            end
        end
        puts "Done"
    end
end
