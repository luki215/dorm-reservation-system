# This will guess the User class
FactoryBot.define do
    factory :user do
        fullname { Faker::Name.name  }
        email { Faker::Internet.safe_email }
        password { Faker::Internet.password }
        admin { false }

        factory :user_male do 
            male {true}
        end

        factory :user_female do 
            male {false}
        end
            
        trait :same_sex_room do 
            same_sex_room {true}
        end

        trait :same_sex_cell do 
            same_sex_room {true}
            same_sex_cell {true}
        end
        
        factory :admin do 
            admin { true }
        end
    end
  end