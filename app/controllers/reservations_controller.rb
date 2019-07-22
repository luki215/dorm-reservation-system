class ReservationsController < ApplicationController
  before_action :set_place, only: [:create, :destroy]

  def create
    current_user.place&.touch
    current_user.place = @place
    current_user.save!
    @place.touch
    redirect_back(fallback_location: places_path)
  end

  def create_for_alliance
    @alliance = Aliance.find(params[:aliance_id])
    cell = params[:cell]
    @places_on_cell = Place.where(cell: cell)

    males = @alliance.users.where(male: true)
    females = @alliance.users.where(male: false)
    
    # first accomodate the sex who makes reservation :D 
    personFront = current_user.male ? males + females : females + males

    while person = personFront.pop
      place = @places_on_cell.pop
      person.place = place
      if person.save
        place.touch
      else
        personFront.push(person)
      end
    end

  end

  def destroy
    current_user.place&.touch
    current_user.place = nil
    current_user.save!
    redirect_back(fallback_location: places_path)
  end

  private
  def set_place
    @place = Place.find(params[:place_id])
  end
end
