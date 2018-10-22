module Api
    module V1
  
      class JirausersController < ApiController
        before_action :require_login
        before_action :get_jira_client
        before_action :set_project, only: [:show, :update, :destroy]
  
        # GET /issuetypes
        def index
          users = @jira_client.User.all
          items = []
          users.each do |user|
            items.push(user.attrs)
            @users = items
          end
  
          render json: @users
        end
  
      end
    end
  end