class ApplicationController < ActionController::Base
    def unauthorized 
        respond_to do |format|
            format.html { redirect_to "/", alert: "You don't have rights to access this page" }
        end
    end

    def admin_only
        unless(current_user.admin)
            unauthorized
        end
    end
end
