module Api
    module V1
  
      class IssuetypesController < ApiController
        before_action :require_login
        before_action :get_jira_client
        before_action :set_project, only: [:show, :update, :destroy]
  
        # GET /issuetypes
        def index
          issuetypes = @jira_client.Issuetype.all
          items = []
          issuetypes.each do |type|
            items.push(type.attrs)
            @issuestypes = items
          end
  
          render json: @issuestypes
        end
  
      end
    end
  end