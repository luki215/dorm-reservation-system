require 'rails_helper'

RSpec.describe Place, type: :model do
  describe "Validations" do 
    it 'Female-only room new female on room is valid'
    it 'Female-only room new male on cell is valid'
    it 'Female-only room new female on cell is valid'
    it 'Female-only room new male on room is invalid'
    it 'Female-only room new male on cell is valid'

    it 'Female-only cell new female on cell is valid'
    it 'Female-only cell new male on cell is invalid'
    it 'Female-only cell new male on room is invalid'

    it 'Male-only room new male on room is valid'
    it 'Male-only room new male on cell is valid'
    it 'Male-only room new female on cell is valid'
    it 'Male-only room new female on room is invalid'
    it 'Male-only room new male on cell is valid'

    it 'Male-only cell new male on cell is valid'
    it 'Male-only cell new female on cell is invalid'
    it 'Male-only cell new female on room is invalid'
  end
end
