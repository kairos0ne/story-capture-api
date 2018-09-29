 
 module Api
    module V1
        # app/controllers/jira_sessions_controller.rb
        class JiraSessionsController < ApiController
            before_action :get_jira_client
        
            def new
            callback_url = 'http://localhost:8080/auth/callback'
            request_token = @jira_client.request_token(oauth_callback: callback_url)
            session[:request_token] = request_token.token
            session[:request_secret] = request_token.secret
        
            redirect_to request_token.authorize_url
            end
        
            def authorize
            request_token = @jira_client.set_request_token(
                session[:request_token], session[:request_secret]
            )
            access_token = @jira_client.init_access_token(
                :oauth_verifier => params[:oauth_verifier]
            )
        
            session[:jira_auth] = {
                :access_token => access_token.token,
                :access_key => access_token.secret
            }
        
            session.delete(:request_token)
            session.delete(:request_secret)
        
            redirect_to projects_path
            end
        
            def destroy
            session.data.delete(:jira_auth)
            end
        end
    end
end