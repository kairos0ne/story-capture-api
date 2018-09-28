module Api
  module V1
    class ApiController < ActionController::Base
      include Rails::Pagination

      def require_login
        authenticate_token || render_unauthorized("Access denied")
      end
    
      def current_user
        @current_user ||= authenticate_token
      end
      
      rescue_from "AccessGranted::AccessDenied" do |exception|
        render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json, :status => :forbidden
      end

      # rescue_from JIRA::OauthClient::UninitializedAccessTokenError do
      #   redirect_to 'https://accounts.atlassian.com/authorize?audience=api.atlassian.com&client_id=LqD8mcIP6oiE1itB4lB4xChOCZWH4iqR&scope=read%3Ajira-user%20read%3Ajira-work%20manage%3Ajira-project%20write%3Ajira-work&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Fauth%2Fcallback&state=${YOUR_USER_BOUND_VALUE}&response_type=code&prompt=consent'
      # end

      protected
    
      def render_unauthorized(message)
        errors = { errors: [ { detail: message } ] }
        render json: errors, status: :unauthorized
      end
    
      private

      def get_jira_client

        # add any extra configuration options for your instance of JIRA,
        # e.g. :use_ssl, :ssl_verify_mode, :context_path, :site
        options = {
          :site               => 'http://monochrome-development.atlassian.net:443/',
          :private_key_file   => "rsakey.pem",
          :rest_base_path     => "/rest/api/3",
          :consumer_key => 'pgjKXqZD9CZ8OBtr',
        }
    
        @jira_client = JIRA::Client.new(options)
    
        # Add AccessToken if authorised previously.
        if session[:jira_auth]
          @jira_client.set_access_token(
            session[:jira_auth]['access_token'],
            session[:jira_auth]['access_key']
          )
        end
      end
    
      def authenticate_token
        authenticate_with_http_token do |token, options|
          # Compare the tokens in a time-constant manner, to mitigate timing attacks.
          if user = User.with_unexpired_token(token, 2.days.ago)
      
            ActiveSupport::SecurityUtils.secure_compare(
                            ::Digest::SHA256.hexdigest(token),
                            ::Digest::SHA256.hexdigest(user.token))
            user
          end
        end
      end
    end
  end
end
