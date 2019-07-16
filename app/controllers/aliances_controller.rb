class AliancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_aliance, only: [:show, :edit, :update, :destroy]

  # GET /aliances
  # GET /aliances.json
  def index
    @aliances = Aliance.all
  end

  # GET /aliances/1
  # GET /aliances/1.json
  def show
  end

  # GET /aliances/new
  def new
    @aliance = Aliance.new()
  end

  # GET /aliances/1/edit
  def edit
  end

  # POST /aliances
  # POST /aliances.json
  def create
    @aliance = Aliance.new(aliance_params)
    @aliance.founder = current_user

    respond_to do |format|
      if @aliance.save
        format.html { redirect_to @aliance, notice: 'Aliance was successfully created.' }
        format.json { render :show, status: :created, location: @aliance }
      else
        format.html { render :new }
        format.json { render json: @aliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aliances/1
  # PATCH/PUT /aliances/1.json
  def update
    respond_to do |format|
      if @aliance.update(aliance_params)
        format.html { redirect_to @aliance, notice: 'Aliance was successfully updated.' }
        format.json { render :show, status: :ok, location: @aliance }
      else
        format.html { render :edit }
        format.json { render json: @aliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aliances/1
  # DELETE /aliances/1.json
  def destroy
    @aliance.destroy
    respond_to do |format|
      format.html { redirect_to aliances_url, notice: 'Aliance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aliance
      @aliance = Aliance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def aliance_params
      params.require(:aliance).permit(:name, :note)
    end
end
