require 'rails_helper'

RSpec.describe SwitchRoomsController, type: :controller do
    before(:all) do
        AppSetting.create(is_running: true)
    end
    describe "POST accept" do
        it "swaps rooms and prints notice" do
            place1 = create(:place_male)
            user1 = place1.user
            place2 = create(:place_male)
            user2 = place2.user

            switch_request = SwitchRoom.create!(user_requesting: user2, user_requested: user1)
            login_user(user1)
            post :accept, params: {id: switch_request.id}
            place1.reload
            place2.reload
            expect(place1.user.id).to eq user2.id
            expect(place2.user.id).to eq user1.id
            expect(response).to redirect_to(switch_rooms_url)
            expect(flash[:notice]).not_to be_empty
        end


        it "can be accepted only by requested user" do
            place1 = create(:place_male)
            user1 = place1.user
            place2 = create(:place_male)
            user2 = place2.user

            switch_request = SwitchRoom.create!(user_requesting: user2, user_requested: user1)

            post :accept, params: {id: switch_request.id}
            expect_unauthorized(response)

            login_user(user2)

            post :accept, params: {id: switch_request.id}
            expect_unauthorized(response)

        end

        it "sex invalid prints alert" do 
            # changing user
            place1 = create(:place_male)
            user1 = place1.user
            # neighbor with sex restriction
            create(:place_male_only_room)

            place2 = create(:place_female, building: 'B')
            user2 = place2.user

            switch_request = SwitchRoom.create!(user_requesting: user2, user_requested: user1)
            login_user(user1)
            post :accept, params: {id: switch_request.id}
            place1.reload
            place2.reload
            expect(place1.user.id).to eq user1.id
            expect(place2.user.id).to eq user2.id
            expect(response).to redirect_to(switch_rooms_url)
            expect(flash[:alert]).not_to be_empty
        end
    

    end
end
