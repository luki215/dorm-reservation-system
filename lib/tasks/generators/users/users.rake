namespace :generators do
    namespace :users do 

      desc "Generate Users"
      task :users => :environment do
          puts "Generating users..."
          User.transaction do
            User.create(
                email: "admin@example.com",
                password: "123456",
                admin: true,
            )
            
            File.open("tmp/users.csv", "r").each_line do |line|
                data = line.split(":")

                begin
                  u = User.create!(
                        {
                            email: data[0],
                            password: "123456",
                            fullname: data[2],
                            male: data[3] == "Muz",
                            room_type: data[1]
                        }
                  )

                  primary_room = data[4].strip
                  secondary_room = data[5].strip
                  
                  if primary_room == secondary_room
                    place_primary = Place.where(primary_claim: nil, secondary_claim: nil, room: primary_room).first 
                  else  
                    place_primary = Place.where(room: primary_room, primary_claim: nil).where.not(secondary_claim: nil).first
                    place_primary ||= Place.where(room: primary_room, primary_claim: nil).first
                    
                    place_secondary = Place.where(room: secondary_room, secondary_claim: nil).where.not(primary_claim: nil).first
                    place_secondary ||= Place.where(room: secondary_room, secondary_claim: nil).first
                  end

                  place_primary&.primary_claim = u 
                  place_primary&.save!
                  place_secondary&.secondary_claim = u 
                  place_secondary&.save!

                  puts "Not found primary #{primary_room}" if primary_room != "" && place_primary.nil?
                  puts "Not found secondary #{secondary_room}" if primary_room != secondary_room && secondary_room != "" && place_secondary.nil? 

                rescue
                  puts "fail for #{data[0]}"
                  raise
                end
            end
          end
          puts "Generated successfully"
      end
    end
end