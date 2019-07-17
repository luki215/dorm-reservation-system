namespace :generators do
    task :create_rooms => :environment do
        puts "Generating rooms..."

        floors = {A: 20, B: 16}
        roomsCount = {A: 26, B: 16}
        bedsInRoomCount = 2

        [:A, :B].each do | building | 
            (1..floors[building]).each do | floor |
                (1..roomsCount[building]).each_slice(2) do |room1, room2| 
                    room_1_str = room1.to_s.rjust(2, '0')
                    room_2_str = room2.to_s.rjust(2, '0')

                    (1..bedsInRoomCount).each do |bedsInRoom| 
                        Place.create!(building: building, 
                                    floor: floor.to_s, 
                                    cell: "#{building}#{floor}#{room_1_str}/#{building}#{floor}#{room_2_str}",
                                    room: "#{room_1_str}",
                                    bed: bedsInRoom.to_s
                        )
                        
                        Place.create!(building: building, 
                            floor: floor.to_s, 
                            cell: "#{building}#{floor}#{room_1_str}/#{building}#{floor}#{room_2_str}",
                            room: "#{room_2_str}",
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
       
        (1..1000).each do |i| 
            puts "generated #{i/10}%" if i % 10 == 0

            User.create!(
                {
                    email: "user#{i}@example.com", 
                    password: "123456",
                    fullname: "User #{i}",
                    male: rand() > 0.5
                }
            )
        end
        User.create(
            email: "admin@example.com",
            password: "123456",
            admin: true,
        )
        puts "Gnerated successfully"
    end

end
