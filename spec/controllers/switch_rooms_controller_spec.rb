require 'rails_helper'

RSpec.describe SwitchRoomsController, type: :controller do
    before(:all) do
        AppSetting.create(is_running: true)
    end
    describe "POST accept" do
        it "switches rooms" do
            place1 = create(:place)
            user1 = place1.user
            place2 = create(:place)
            user2 = place2.user

            switch_request = SwitchRoom.create!(user_requesting: user2, user_requested: user1)
            login_user(user1)
            post :accept, params: {id: switch_request.id}
            place1.reload
            place2.reload
            expect(place1.user.id).to eq user2.id
            expect(place2.user.id).to eq user1.id
        end

        it "notice on successfull switch" do
            get :index
            expect(response).to render_template("index")
        end


        it "sex invalid returns alert" do
          team = Team.create
          get :index
          expect(assigns(:teams)).to eq([team])
        end
    

    end
end
