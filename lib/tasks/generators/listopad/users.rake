namespace :generators do
    namespace :listopad do 
        desc "Generate Users for Listopad"
        task :users => :environment do
            puts "Generating users..."
       
            User.create(
                email: "admin@example.com",
                password: "123456",
                admin: true,
            )

            (1..20).each do |i| 
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
            puts "Generated successfully"
        end
    end
end
