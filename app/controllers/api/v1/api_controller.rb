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

      rescue_from JIRA::OauthClient::UninitializedAccessTokenError do
        render :json => {:error => "Something went wrong unable to authenticate"}.to_json, :status => :forbidden
      end

      # rescue_from JIRA::HTTPError::JIRA::HTTPError do
      #   render :json => {:error => "HTTP Error"}.to_json
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
          :user => 'Scott',
          :password => ENV['API_KEY2'],
          :site => 'https://monochrome-development.atlassian.net/',
          :context_path => '',
          :auth_type => :basic,
          :consumer_key => ENV['CONSUMER_KEY']
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
