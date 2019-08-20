namespace :generators do
    namespace :kajka do 
        desc "Generate Rooms for Kajetanka"
        task :rooms => :environment do

            puts "Generating rooms..."

            puts "K2..."
            # Rooms 2A-BCCd, A = building [A, B], B = floor, CC = cell, d = room [a, b]
            floors = [*0..5]
    
            puts "K2A..."
            building = "2A"
            cellCount = {
                0 => [*1..7, 13],
                1 => [*5..10, 12, 13],
                2 => [*1..13, 16],
                3 => [*1..13, 16],
                4 => [*1..13, 16],
                5 => [*1..13, 16]
            }
            floors.each do | floor |
                cellCount[floor].each do | cell |
                    cell_str = cell.to_s.rjust(2, '0') # 1 -> 01
                    unbound = true

                    # Restrict lector rooms
                    # K2 A - 213
                    if floor == 2 and cell == 13
                        unbound = false
                    end
    
                    if cell != 13
                        # Cells 2+2
                        (:a..:b).each do |roomInCell|
                            (1..2).each do |bedInRoom|
                                Place.create!(building: building,
                                              floor: floor.to_s,
                                              cell: "#{building}-#{floor}#{cell_str}",
                                              room: "#{building}-#{floor}#{cell_str}#{roomInCell}",
                                              bed: bedInRoom.to_s,
                                              room_type: unbound ? "KAJ 2LS" : "KAJ RESERVED"
                                )
                            end
                        end
                    else
                        # Cells 2+0
                        (1..2).each do |bedInRoom|
                            Place.create!(building: building,
                                          floor: floor.to_s,
                                          cell: "#{building}-#{floor}#{cell_str}",
                                          room: "#{building}-#{floor}#{cell_str}",
                                          bed: bedInRoom.to_s,
                                          room_type: unbound ? "KAJ 2LS" : "KAJ RESERVED"
                            )
                        end
                    end
                end
            end
    
            puts "K2B..."
            building = "2B"
            cellCount = {
                0 => [*1..6, 9], # 9a = 9, 9b = 10 in real
                1 => [*1..14],
                2 => [*1..14],
                3 => [*1..14],
                4 => [*1..14],
                5 => [*1..14]
            }
            floors.each do | floor |
                cellCount[floor].each do | cell |
                    cell_str = cell.to_s.rjust(2, '0') # 1 -> 01
    
                    # Cells 2+2
                    (:a..:b).each do |roomInCell|
                        (1..2).each do |bedInRoom|
                            Place.create!(building: building,
                                          floor: floor.to_s,
                                          cell: "#{building}-#{floor}#{cell_str}",
                                          room: "#{building}-#{floor}#{cell_str}#{roomInCell}",
                                          bed: bedInRoom.to_s,
                                          room_type: "KAJ 2LS"
                            )
                        end
                    end
                end
            end
    
            puts "K1..."
            # Rooms 1A-BBC, A = building [A, B], BB = floor, C = cell
            buildings = ["1A", "1B"]
            floors = [*1..15]
            cellCount = {
                "1A" => {
                    1 => [],
                    2 => [*1..4],
                    3 => [*1..4, 7, 8],
                    4 => [*1..4, 7, 8],
                    5 => [],
                    6 => [],
                    7 => [*1..4, 7, 8],
                    8 => [*1..4, 7, 8],
                    9 => [*1..4, 7, 8],
                    10 => [*1..4, 7, 8],
                    11 => [*1..4, 7, 8],
                    12 => [*1..4, 7, 8],
                    13 => [*1..4, 7, 8],
                    14 => [*1..4, 7, 8],
                    15 => [*1..4, 7, 8]
                },
                "1B" => {
                    1 => [],
                    2 => [],
                    3 => [],
                    4 => [*1..8],
                    5 => [*1..8],
                    6 => [*1..8],
                    7 => [*1..8],
                    8 => [*1..8],
                    9 => [*1..8],
                    10 => [*1..8],
                    11 => [*1..8],
                    12 => [*1..8],
                    13 => [*1..8],
                    14 => [*1..8],
                    15 => [*1..8]
                }
            }
            buildings.each do | building |
                floors.each do | floor |
                    cellCount[building][floor].each do | cell |
                        unbound = true
                        # Cells 2+1

                        # Restrict lector rooms
                        # K1 A – 24 a 26
                        if building == "1A" and floor == 2 and [4,6].include? cell
                            unbound = false
                        end

                        (1..2).each do |bedInRoom|
                            Place.create!(building: building,
                                          floor: floor.to_s,
                                          cell: "#{building}-#{floor}#{cell}",
                                          room: "#{building}-#{floor}#{cell}/2",
                                          bed: bedInRoom.to_s,
                                          room_type: unbound ? "KAJ 2LS" : "KAJ RESERVED"
                            )
                        end

                        # Restrict lector rooms
                        # K1 A – 73/1, 74/1, 75/1, 77/1, 78/1
                        if building == "1A" and floor == 7 and [3,4,5,7,8].include? cell
                            unbound = false
                        end

                        Place.create!(building: building,
                                      floor: floor.to_s,
                                      cell: "#{building}-#{floor}#{cell}",
                                      room: "#{building}-#{floor}#{cell}/1",
                                      bed: 1,
                                      room_type: unbound ? "KAJ 1LS" : "KAJ RESERVED"
                        )
                    end
                end
            end
    
            puts "Gnerated successfully"
            
        end
    end
end
