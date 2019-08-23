class SwitchRoomsController < ApplicationController
  before_action :set_switch_room, only: [:accept, :destroy]

  def index
    @requests_made = SwitchRoom.where(user_requesting: current_user)
    @requests_incoming = SwitchRoom.where(user_requested: current_user)
  end

  # GET /switch_rooms/new
  def new
    @place = Place.find(params[:place_id])
    @switch_room = SwitchRoom.new
  end

  def create
    
    @place = Place.find(params[:place_id])

    @switch_room = SwitchRoom.new(user_requesting: current_user, user_requested: @place.user, note: params[:switch_room][:note])

    respond_to do |format|
      if @place.available_for_switch_with?(current_user) && @switch_room.save
        format.html { redirect_to places_path, notice: t('switch.request_successfully_created') }
      elsif @switch_room.errors.size > 0
        format.html { render :new }
      else
        flash.now[:notice] = t('switch.request_available_error')
        format.html { render :new }
      end
    end
  end

  # DELETE /switch_rooms/1
  # DELETE /switch_rooms/1.json
  def destroy
    @switch_room.destroy
    respond_to do |format|
      format.html { redirect_to switch_rooms_url, notice: 'Switch room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def accept

    return unauthorized if !current_user || current_user.id != @switch_room.user_requested.id
    
    requests_to_destroy = 
    SwitchRoom.where(user_requesting: @switch_room.user_requested).or(
      SwitchRoom.where(user_requesting: @switch_room.user_requesting)
    ).or(
      SwitchRoom.where(user_requested: @switch_room.user_requesting)
    ).or(
      SwitchRoom.where(user_requested: @switch_room.user_requested)
    )
    place_requesting = @switch_room.user_requesting.place
    place_requested = @switch_room.user_requested.place

    begin 
    User.transaction do 
      Place.transaction do
        SwitchRoom.transaction do 
          requests_to_destroy.destroy_all
          place_requested.user = nil
          place_requesting.user = nil
          place_requested.save!
          place_requesting.save!
          place_requested.user = @switch_room.user_requesting
          place_requesting.user = @switch_room.user_requested
          place_requested.save!
          place_requesting.save!
        end
      end
    end
    @errors = []
    rescue ActiveRecord::RecordInvalid
      @errors = place_requesting.errors[:sex]
      @errors += place_requested.errors[:sex]
      @errors << I18n.t("general.unknown_error") if @errors.empty? 
    end


    respond_to do |format|
      if @errors.empty?
        format.html { redirect_to switch_rooms_url, notice: 'Rooms switched successfully' }
      else
        format.html { redirect_to switch_rooms_url, alert: @errors.join(", ") }
      end
    end
    
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_switch_room
      @switch_room = SwitchRoom.find(params[:id])
    end
end
