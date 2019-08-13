class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    admin_only
    @users = User.students.order(:fullname).page params[:page]
  end

  # GET /users/1/edit
  def edit
    self_or_admin_only
  end
  
  def welcome(passwd)
    @user.password = passwd
    UserMailer.welcome_email(@user.email,passwd).deliver_now
  end
  
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    self_or_admin_only
    attrs = user_params
    attrs[:same_sex_room] = attrs[:same_sex_cell] if attrs[:same_sex_cell] == "1"

    if attrs[:password] != attrs[:password_confirmation] 
      flash.now[:alert] = "Passwords don't match"
      return (respond_to {|format| format.html {render :edit}}) 
    end

    @user.place&.touch if attrs[:same_sex_room] || attrs[:same_sex_cell]
    respond_to do |format|
      if @user.update(attrs)
        red = current_user.admin ? users_path : "/"
        target = current_user.admin ? t("activerecord.models.user") : t(".your_profile")
        format.html { redirect_to red, notice: target + ' byl úspěšně změněn.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find(params[:id])    
      rescue ActiveRecord::RecordNotFound
        nonexistent_user
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if (current_user.admin)
        params.require(:user).permit(:male, :email, :fullname, :same_sex_room, :same_sex_cell, :note, :room_type, :password, :password_confirmation)
      else
        params.require(:user).permit(:same_sex_room, :same_sex_cell, :note, :password, :password_confirmation)
      end
    end

    def self_or_admin_only
      unless(current_user.admin || current_user.id == @user.id)
          unauthorized
      end
    end

end
