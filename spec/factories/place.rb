FactoryBot.define do
    factory :place do
        building { "A" }
        floor { 14 }
        room { "01" }
        cell {"A1401"}
        association :user
        
        factory :place_male_only_room do 
            association :user, factory: [:user, :user_male, :same_sex_room]
        end

        factory :place_male_only_cell do 
            association :user, factory: [:user, :user_male, :same_sex_cell]
        end

        factory :place_female_only_cell do 
            association :user, factory: [:user, :user_female, :same_sex_cell]
        end

        factory :place_female_only_room do
            association :user, factory: [:user, :user_female, :same_sex_room]
        end
    end
end