namespace :generators do
    namespace :users do 
        desc "Generate AppSettings for Listopad"
        task :move_by_claims => :environment do
            puts "Moving according to place claims"
            Place.transaction do 
                places_with_claims = Place.where.not(primary_claim: nil).or(Place.where.not(secondary_claim: nil)).preload(:user, :primary_claim, :secondary_claim)

                places_with_claims.each do | place |
                    begin 
                        if place.user.nil? 
                            places_on_cell = place.places_on_same_cell
                            places_on_cell.each{|place| place.user&.update(same_sex_room: false)}
                            byebug if place.primary_claim&.id == 16
                            place.primary_claim&.update(same_sex_room: false)
                            place.secondary_claim&.update(same_sex_room: false)

                            place.user = place.primary_claim if place.primary_claim&.place.nil?
                            puts "Error moving secondary claim for user #{place.secondary_claim.email}" if place.primary_claim != place.secondary_claim && place.secondary_claim && ! place.user.nil? 
                            place.user ||= place.secondary_claim  if place.secondary_claim&.place.nil?
                            
                            
                            place.save! if place.user && place.user.place.nil? && place.room_type == place.user.room_type

                            begin   
                                place.primary_claim&.update(same_sex_room: true) if place.user != place.primary_claim
                            rescue ActiveRecord::RecordInvalid
                                puts "User changed its sex preference: #{place.primary_claim.email}"
                            end
                            begin   
                                place.secondary_claim&.update(same_sex_room: true) if place.user != place.secondary_claim
                            rescue ActiveRecord::RecordInvalid
                                puts "User changed its sex preference: #{place.primary_claim.email}"
                            end
                            begin   
                                places_on_cell.each{|place| place.user&.update(same_sex_room: true)}
                            rescue ActiveRecord::RecordInvalid
                                puts "User changed its sex preference: #{place.primary_claim.email}"
                            end
                        end
                    rescue 
                         puts "error with processing place #{place.id}; primary claim: #{place.primary_claim&.email}; secondary_claim: #{place.secondary_claim&.email}"
                    end
                end
            end
            puts "End"
        end
    end
end
