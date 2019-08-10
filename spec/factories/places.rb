FactoryBot.define do
    factory :place do
        building { "A" }
        floor { 14 }
        room { "01" }
        cell {"A1401"}
        
        trait :on_cell do 
            room { "02" }
        end

        factory :place_male do 
            association :user, factory: [:user_male]
        end

        factory :place_female do 
            association :user, factory: [:user_female]
        end

        factory :place_male_only_room do 
            association :user, factory: [:user_male, :same_sex_room]
        end

        factory :place_male_only_cell do 
            association :user, factory: [:user_male, :same_sex_cell]
        end

        factory :place_female_only_cell do 
            association :user, factory: [:user_female, :same_sex_cell]
        end

        factory :place_female_only_room do
            association :user, factory: [:user_female, :same_sex_room]
        end
    end
end