namespace :generators do
    task :create_rooms => :environment do
        puts "Gnerating rooms..."

        floors = {A: 20, B: 16}
        roomsCount = {A: 26, B: 16}
        bedsInRoomCount = 2

        [:A, :B].each do | building | 
            (1..floors[building]).each do | floor |
                (1..roomsCount[building]).each do |room| 
                    room_str = room.to_s.rjust(2, '0')
                    (1..bedsInRoomCount).each do |bedsInRoom| 
                        Place.create!(building: building, 
                                    floor: floor.to_s, 
                                    cell: "#{building}#{floor}#{room_str}",
                                    room: "#{room_str}",
                                    bed: bedsInRoom.to_s
                        )
                    end
                end
            end
        end
        puts "Gnerated successfully"
    end

    task :generate_users => :environment do
        puts "Gnerating users..."
        User.create!(
            email: "admin@example.com",
            password: "123456",
            admin: true,
        )

        User.create!(
            email: "user@example.com",
            password: "123456"
        )

        puts "Gnerated successfully"
    end

end
