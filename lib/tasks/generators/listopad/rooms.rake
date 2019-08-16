namespace :generators do
    namespace :listopad do 
        desc "Generate Rooms for Listopad"
        task :rooms => :environment do
            puts "Generating rooms..."

            floors = {A: 20, B: 16}
            roomsCount = {A: 24, B: 16}
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
                                        bed: bedsInRoom.to_s,
                                        room_type: "bla"
                            )
                            
                            Place.create!(building: building, 
                                floor: floor.to_s, 
                                cell: "#{building}#{floor}#{room_1_str}/#{building}#{floor}#{room_2_str}",
                                room: "#{room_2_str}",
                                bed: bedsInRoom.to_s,
                                room_type: "bla"
                            )
                        end
                    end
                end
            end
            puts "Generated successfully"
            
        end
    end
end
