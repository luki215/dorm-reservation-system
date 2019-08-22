namespace :generators do
    namespace :users do 
        desc "Generate AppSettings for Listopad"
        task :move_by_claims => :environment do
            puts "Moving according to place claims"

            Place.transaction do
                puts "Removing sex restrictions"
                User.update_all(same_sex_room: false)

                puts "Auto solving claims"

                Place.preload(:user, primary_claim: [:place], secondary_claim: [:place]).each do | place |
                    begin
                        # Primary claim
                        unless place.primary_claim.nil?
                          # We aware: place.secondary_claim.place == place always !!! be aware
                          primary_claim_place = Place.find_by(user_id: place.primary_claim.id)
                          if place.room_type == place.primary_claim.room_type
                            puts "W: #{place.room} Rewriting bed with #{place.primary_claim.email}" if place != primary_claim_place
                            place.user = place.primary_claim
                          else
                            puts "W: #{place.room} Ignoring primary claim for user #{place.primary_claim.email} (change type #{place.room_type} -> #{place.primary_claim.room_type})"
                          end
                        end

                        # Secondary claim
                        if !place.secondary_claim.nil? and place.user.nil?
                          # We aware: place.secondary_claim.place == place always !!! be aware
                          secondary_claim_place = Place.find_by(user_id: place.secondary_claim.id)
                          if secondary_claim_place.nil? && place.room_type == place.secondary_claim.room_type
                            place.user = place.secondary_claim
                          else
                            if secondary_claim_place.nil? && place.room_type != place.secondary_claim.room_type
                              puts "W: #{place.room} Ignoring secondary claim for user #{place.secondary_claim.email} (change type  #{place.room_type} -> #{place.secondary_claim.room_type})"
                            elsif place != place.secondary_claim.place
                              puts "V: #{place.room} Ignoring secondary claim for user #{place.secondary_claim.email} (has room #{place.secondary_claim.place.room})"
                            end
                          end
                        end

                        place.save! unless place.user.nil?
                    rescue
                        puts "#{place.room} Error; primary claim: #{place.primary_claim&.email}; secondary_claim: #{place.secondary_claim&.email}"
                        raise
                    end
                end

                puts "Restoring sex restrictions"
                User.all.each do | user |
                    begin
                        if user.place.nil?
                          user.update(same_sex_room: true)
                        else
                          sex_on_room = Set.new
                          places_on_room = user.place.places_on_same_room
                          places_on_room.each do | place |
                            sex_on_room << place.user.male unless place.user.nil?
                          end
                          case sex_on_room.size
                          when 0
                            puts "E: No user on room #{user.place}"
                          when 1
                            user.update(same_sex_room: true)
                          else
                            user.update(same_sex_room: false)
                            puts "User changed its sex preference: #{user.email}"
                          end
                        end
                    rescue
                        puts "error with processing user #{user.email}; room: #{user}"
                        raise
                    end
                end
            end
            puts "End"
        end
    end
end
