namespace :generators do
    namespace :users do 
        desc "Generate AppSettings for Listopad"
        task :move_by_claims => :environment do
            places_with_claims = Place.where.not(primary_claim: nil).or(Place.where.not(secondary_claim: nil))

            places_with_claims.each do | place | 
                place.user = place.primary_claim

                place.save!
            end
        end
    end
end
