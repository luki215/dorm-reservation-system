module ControllerMacros

    def login_user(user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    def expect_unauthorized(response)
      expect(response).to be_redirect
      expect(response).to redirect_to "/"
      expect(flash[:alert]).to eq "You don't have rights to access this page"
    end
  end