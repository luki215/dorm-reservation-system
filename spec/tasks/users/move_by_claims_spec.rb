require "rails_helper"

describe "rake generators:users:move_by_claims", type: :task do

  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "runs gracefully" do
    expect { task.execute }.not_to raise_error
  end

  it "moves to primary claim" do
    u = create(:user_male)
    p1 = create(:place, primary_claim: u)

    task.execute
    p1.reload
    expect(p1.user).to eq u
  end
  

  it "moves to secondary claim if not full" do
    u = create(:user_male)
    p1 = create(:place, secondary_claim: u)

    task.execute
    p1.reload
    expect(p1.user).to eq u
  end


  it "moves to first claim if have both" do
    u = create(:user_male)
    p1 = create(:place, secondary_claim: u, primary_claim: u)

    task.execute
    p1.reload
    expect(p1.user).to eq u
  end

  it "doesnt move to secondary claim if place full and puts error" do
    u_origin = create(:user_male)
    u = create(:user_male)

    p1 = create(:place, primary_claim: u_origin, secondary_claim: u)

    expect { task.execute }.to output("Error moving secondary claim for user #{u.email}\n").to_stdout
    p1.reload
    expect(p1.user).to eq u_origin
  end


  it "move primary even to other sex" do
    place_male = create(:place_male_only_room)
    
    u = create(:user_female)

    p1 = create(:place, primary_claim: u )

    task.execute

    p1.reload
    expect(p1.user).to eq u
  end

  it "move secondary even to other sex" do
    place_male = create(:place_male_only_room)
      
    u = create(:user_female)

    p1 = create(:place, secondary_claim: u )

    task.execute

    p1.reload
    expect(p1.user).to eq u
  end

  it "all the users who have not been moved with other sex have sex restriction on room" do 
    u1 = create(:user_female)
    u2 = create(:user_female)
    u3 = create(:user_female)

    p1 = create(:place, primary_claim: u1 )
    p2 = create(:place, secondary_claim: u2 )
    

    task.execute
    u1.reload
    u2.reload
    u3.reload

    expect(u1.same_sex_room).to eq true
    expect(u2.same_sex_room).to eq true
    expect(u3.same_sex_room).to eq true
  end

  it "all users moved with other sex have not room restriction" do
    u1 = create(:user_female)
    u2 = create(:user_female)
    p1_other_sex = create(:place_male_only_room, room: "AAAA" )
    p1 = create(:place, room: "AAAA", primary_claim: u1 )
    p2_other_sex = create(:place_male_only_room, room: "BBBB" )
    p2 = create(:place, room: "BBBB", secondary_claim: u2 )

    task.execute
    u1.reload
    u2.reload

    expect(u1.same_sex_room).to eq false
    expect(u2.same_sex_room).to eq false
  end

end