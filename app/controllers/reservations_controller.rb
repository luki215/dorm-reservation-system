class ReservationsController < ApplicationController
  before_action :set_place

  def create
    current_user.place&.touch
    current_user.place = @place
    current_user.save!
    @place.touch
    redirect_back(fallback_location: places_path)
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
