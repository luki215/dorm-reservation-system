namespace :generators do 
    desc "Generate Users Mocks"
    task :users_mocks => :environment do
        puts "Generating users..."
    
        (1..1000).each do |i| 
            puts "generated #{i/10}%" if i % 10 == 0

            User.create!(
                {
                    email: "zamluvy.kolejeuk+#{i}@gmail.com", 
                    password: "123456",
                    fullname: "User #{i}",
                    male: rand() > 0.5,
                    primary_claim: Place.first,
                    secondary_claim: Place.where(building: "A", floor:"12", room: "01").first,
                    room_type: "bla"
                }
            )
        end
        User.create(
            email: "admin@example.com",
            password: "123456",
            admin: true,
        )
        puts "Generated successfully"
    end
end
