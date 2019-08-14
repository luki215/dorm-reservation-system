class ReservationsController < ApplicationController
  before_action :set_place, only: [:create, :destroy]

  def create
    existing_place = current_user.place
    begin
    Place.transaction do 
      existing_place.user = nil if existing_place
      @place.user = current_user
      existing_place.save! if existing_place
      @place.save!
    end
    rescue ActiveRecord::RecordInvalid
      errors = @place.errors 
    end
    
    # current_user.save!
    @place.touch
    err_to_render = "Reservation not successfull - sex mismatch" if errors && errors[:sex]
    redirect_back(fallback_location: places_path, alert: err_to_render)
  end

  def create_for_alliance
    @alliance = Aliance.find(params[:aliance_id])
    cell = params[:cell]
    @places_on_cell = Place.where(cell: cell,user: nil).to_a
    users = @alliance.users.joins(:place).where.not(place: {cell: cell} ).to_a


    
    
    
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
