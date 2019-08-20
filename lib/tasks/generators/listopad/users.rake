namespace :generators do
    namespace :listopad do 
        desc "Generate Users for Listopad"
        task :users => :environment do
            puts "Generating users..."
File.open("tmp/users.csv", "r").each_line do |line|
  data = line.split(":")

             User.create!(
                    {
                        email: data[0], 
                        password: "123456",
                        fullname: data[1],
                        male: data[2] == "Muz",
                        primary_claim: Place.where(building: data[4][0], floor: data[4][1] + data[4].size==5 ? data[4][2] : "", room: data[4][data[4].size-2]+data[4][data[4].size-1]).first,
                        secondary_claim: Place.where(building: data[5][0], floor: data[5][1] + data[5].size==5 ? data[5][2] : "", room: data[5][data[5].size-2]+data[5][data[5].size-1]).first,
                        room_type: data[3]
                    }
                )
    


end
       
            (1..1000).each do |i| 
                puts "generated #{i/10}%" if i % 10 == 0
    
           end
            User.create(
                email: "admin@example.com",
                password: "123456",
                admin: true,
            )
            puts "Generated successfully"
        end
    end
end
