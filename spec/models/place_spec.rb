require 'rails_helper'

RSpec.describe Place, type: :model do
  describe "Validations" do 
    it 'Female-only room new female on room is valid' do
      p1 = create(:place_female_only_room)
      p_new = create(:place)
      p_new.user = create(:user_female)

      expect(p_new).to be_valid
    end
    
    it 'Female-only room new male on cell is valid' do
      p1 = create(:place_female_only_room)
      p_new = create(:place)
      p_new.user = create(:user_male)

      expect(p_new).not_to be_valid
    end

    it 'Female-only room new female on cell is valid' do 
      p1 = create(:place_female_only_room)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_female)

      expect(p_new).to be_valid
    end

    it 'Female-only room new male on room is invalid' do 
      p1 = create(:place_female_only_room)
      p_new = create(:place)
      p_new.user = create(:user_male)

      expect(p_new).not_to be_valid
    end

    it 'Female-only room new male on cell is valid' do 
      p1 = create(:place_female_only_room)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_male)

      expect(p_new).to be_valid
    end

    it 'Female-only cell new female on cell is valid' do 
      p1 = create(:place_female_only_cell)
      p_new = create(:place)
      p_new.user = create(:user_female)

      expect(p_new).to be_valid
    end

    it 'Female-only cell new male on cell is invalid' do 
      p1 = create(:place_female_only_cell)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_male)

      expect(p_new).not_to be_valid
    end

    it 'Female-only cell new male on room is invalid' do 
      p1 = create(:place_female_only_cell)
      p_new = create(:place)
      p_new.user = create(:user_male)

      expect(p_new).not_to be_valid
    end

    it 'Male-only room new male on room is valid' do 
      p1 = create(:place_male_only_room)
      p_new = create(:place)
      p_new.user = create(:user_male)

      expect(p_new).to be_valid
    end

    it 'Male-only room new male on cell is valid' do 
      p1 = create(:place_male_only_room)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_male)

      expect(p_new).to be_valid
    end

    it 'Male-only room new female on cell is valid' do 
      p1 = create(:place_male_only_room)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_female)

      expect(p_new).to be_valid
    end

    it 'Male-only room new female on room is invalid' do 
      p1 = create(:place_male_only_room)
      p_new = create(:place)
      p_new.user = create(:user_female)

      expect(p_new).not_to be_valid
    end


    it 'Male-only room new male on cell is valid' do 
      p1 = create(:place_male_only_room)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_male)

      expect(p_new).to be_valid
    end

    it 'Male-only cell new male on cell is valid' do 
      p1 = create(:place_male_only_cell)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_male)

      expect(p_new).to be_valid
    end

    it 'Male-only cell new female on cell is invalid' do 
      p1 = create(:place_male_only_cell)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_female)

      expect(p_new).not_to be_valid
    end

    it 'Male-only cell new female on room is invalid' do 
      p1 = create(:place_male_only_cell)
      p_new = create(:place)
      p_new.user = create(:user_female)

      expect(p_new).not_to be_valid
    end

    it 'Me - male_only_room on cell with male is valid' do
      p1 = create(:place_male)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_male, :same_sex_room)

      expect(p_new).to be_valid
    end


    it 'Me - male_only_room on cell with female is valid' do
      p1 = create(:place_female)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_male, :same_sex_room)

      expect(p_new).to be_valid
    end

    it 'Me - male_only_room on room with male is valid' do
      p1 = create(:place_male)
      p_new = create(:place)
      p_new.user = create(:user_male, :same_sex_room)

      expect(p_new).to be_valid
    end

    it 'Me - male_only_room on room with female is invalid' do
      p1 = create(:place_female)
      p_new = create(:place)
      p_new.user = create(:user_male, :same_sex_room)

      expect(p_new).not_to be_valid
    end

    it 'Me - male_only_cell on cell with female is invalid' do
      p1 = create(:place_female)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_male, :same_sex_cell)

      expect(p_new).not_to be_valid
    end

    it 'Me - male_only_cell on room with female is invalid' do
      p1 = create(:place_female)
      p_new = create(:place)
      p_new.user = create(:user_male, :same_sex_cell)

      expect(p_new).not_to be_valid
    end

    it 'Me - male_only_cell on room with male is valid' do
      p1 = create(:place_male)
      p_new = create(:place)
      p_new.user = create(:user_male, :same_sex_cell)

      expect(p_new).to be_valid
    end

    it 'Me - male_only_cell on cell with male is valid' do
      p1 = create(:place_male)
      p_new = create(:place, :on_cell)
      p_new.user = create(:user_male, :same_sex_cell)

      expect(p_new).to be_valid
    end



  end
end
