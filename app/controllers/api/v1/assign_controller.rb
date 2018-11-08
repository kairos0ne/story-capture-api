module Api
    module V1
      class AssignController < ApiController
        before_action :require_login
        before_action :get_jira_client
        before_action :set_project, only: [:show, :update, :destroy]
  

        # POST /issue
        def create
          client = @jira_client
          issue = client.Issue.find(params[:key])
          person_name = params[:person_name]
          if params[:person_name]
            begin
                issue.save({'fields' => {'assignee' => {'name' => person_name}}})
            rescue JIRA::HTTPError => e
              puts e.response.code
              puts e.response.message
              puts e.response.body  
            end 
          else
            render :json => {:error => "You need to provide a name for the assignee"}.to_json
          end
        end
      end
    end
  end