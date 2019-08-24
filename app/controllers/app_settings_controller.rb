require 'securerandom'

class AppSettingsController < ApplicationController
  before_action :set_app_setting, only: [:edit, :update]

  # GET /app_settings
  # GET /app_settings.json
  def index
    admin_only
    @app_settings = AppSetting.first
    @users_count = User.where(admin: false).size
    @users_welcome_sent_count = User.where(welcome_mail_sent: true, admin: false).size
    @users_apollogize_sent_count = User.where(apollogize_mail_sent: true, admin: false).size

  end

  def update
    admin_only
    respond_to do |format|
      if @app_setting.update(app_setting_params)
        format.html { redirect_to app_settings_path, notice: 'App setting was successfully updated.' }
      else
        format.html { render :index }
      end
    end
  end

  def send_welcome_mails
    admin_only
    
    SendWelcomeMailsWorker.perform_async

    respond_to do |format|
      format.html { redirect_to app_settings_url, notice: 'Emails are sending' }
      format.json { head :no_content }
    end
  end

  def send_apollogize_mails
    User.where(admin: false, apollogize_mail_sent: false).select(:id).each_with_index do |user, j|
      ApollogizeMailWorker.perform_in( ((j / 200)*5).minutes, user.id)
    end 
    
    respond_to do |format|
      format.html { redirect_to app_settings_url, notice: 'Emails are sending' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_setting
      @app_setting = AppSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_setting_params
      params.require(:app_setting).permit(:first_round_start, :second_round_start, :third_round_start, :fourth_round_start, :is_running)
    end
end
