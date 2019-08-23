class SetLanguageController < ApplicationController
    def english
        I18n.locale = :en
        set_session_and_redirect
      end
    
      def czech
        I18n.locale = :cs
        set_session_and_redirect
      end
    
      private
      def set_session_and_redirect
        session[:locale] = I18n.locale
        redirect_back(fallback_location: "/", turbolinks: false)
      end
end
