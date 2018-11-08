module Api
  module V1

    class IssuesController < ApiController
      before_action :require_login
      before_action :get_jira_client
      before_action :set_project, only: [:show, :update, :destroy]

      # GET /issues
      def index
        
      max_results_per_query = 100
      issues = []
      loop do
        issues_results = @jira_client.Issue.jql("PROJECT = " + params[:key].to_s, max_results: max_results_per_query, start_at: issues.size)
        issues.push(*issues_results)
        items = []
        issues.each do |issue|
          items.push(issue.attrs)
          @issues = items
        end
        break if issues_results.size == 0
      end
        render json: @issues
      end

      # Get /issue
      def show
        if params[:key]
          issue = @jira_client.Issue.find(params[:key])
          @item = issue.attrs
          
          render :json => {:issue => @item}.to_json
        else
          render :json => {:error => "You need to provide a key for the issue"}.to_json
        end
      end
      # POST /issue
      def create
        client = @jira_client
        issue = client.Issue.build
        summary = params[:summary]
        projectId = params[:project_id]
        projectKey = params[:project_key]
        issueTypeId = params[:issuetype_id]
        parent_key = params[:parent_key]
        if params[:parent_key]
          begin
            issue.save!(
              {"fields"=> {
                "summary" => summary,
                "project" => {
                  "id" => projectId,
                },
                "issuetype"=> {
                  "id"=> issueTypeId,
                },
                "parent" => {
                  "key" => parent_key,
                }
                }
              })
          rescue JIRA::HTTPError => e
            puts e.response.code
            puts e.response.message
            puts e.response.body  
          end 
        else
          begin
            issue.save!(
              {"fields"=> {
                "summary" => summary,
                "project" => {
                  "id" => projectId,
                },
                "issuetype"=> {
                  "id"=> issueTypeId,
                }
                }
              })
          rescue JIRA::HTTPError => e
            puts e.response.code
            puts e.response.message
            puts e.response.body  
          end
          issue.fetch
          @issue = issue
          render :json @issue 
        end
      end

      # PATCH/PUT /projects/1
      def update
    
      end

      # DELETE /projects/1
      def destroy
    
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_project
          
        end

        # Only allow a trusted parameter "white list" through.
        def project_params
          params.require(:project).permit(:project, :description, :client_id)
        end
    end
  end
end