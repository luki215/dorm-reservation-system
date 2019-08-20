class ApplicationController < ActionController::Base
    protect_from_forgery prepend: true, with: :exception
    before_action :check_app_running
    before_action :set_paper_trail_whodunnit
    before_action :set_raven_context

    def unauthorized 
        respond_to do |format|
            format.html { redirect_to "/", alert: "You don't have rights to access this page" }
        end
    end

    def admin_only
        unless(current_user&.admin)
            unauthorized
        end
    end

    private 
    def check_app_running
        if !AppSetting.first.is_running && 
            controller_name != "not_running" && 
            controller_name != "app_settings" && 
            controller_name != "sessions" &&
            controller_name != "passwords"

            redirect_to not_running_index_path 
        end
    end

    def set_raven_context
        Raven.user_context(id: current_user.id, mail: current_user.email) if current_user
        Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end

    def nonexistent_user
        respond_to do |format|
            format.html { redirect_to "/", alert: "This user doesn't exist!" }
        end
    end


end
