class PlacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  # GET /places
  # GET /places.json
  def index
    @params = params.permit(:building, :floor)
    
    @buildings = Place.distinct.pluck(:building)
    @floors = Place.where(building:params[:building]).distinct.order(:floor).pluck(:floor) if @params[:building]
    @current_user_place = current_user.place
    if @params[:building] && @params[:floor]
      @cells = Place.where(building: @params[:building], floor: @params[:floor]).order(:room, :id).includes(:user).group_by{|i| i.cell}
    end
  end

  # GET /places/1/edit
  def edit
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    admin_only
    
    respond_to do |format|
      params = place_params
      params = params.except(:room_type) if params[:room_type] == ""
      params[:user_id] = nil if params[:user_id] == ""
      @place.skip_round_validation = true
  
      if @place.update(params)
        format.html { redirect_to places_path, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      return params.require(:place).permit(:room_type, :user_id) if current_user.admin?
      return params.require(:place).permit() unless current_user.admin?
    end
end
