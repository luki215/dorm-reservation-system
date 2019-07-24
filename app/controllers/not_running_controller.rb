class NotRunningController < ApplicationController
  def index
    redirect_to authenticated_root_path if AppSetting.first.is_running
  end
end
