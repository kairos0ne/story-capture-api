module Api
    module V1
      class TokenController < ApiController
        before_action :require_login
        before_action :set_auth, only: [:show, :update, :destroy]
  
        # GET /auths/1
        def token
            user = current_user
            token = ENV['API_KEY']
            @encodeString = current_user.email + ':' + token
            @encodedString = Base64.urlsafe_encode64(@encodeString)
            render :json => {:token => @encodedString}
        end
      end
    end 
  end