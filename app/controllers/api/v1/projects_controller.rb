module Api
  module V1

    class ProjectsController < ApiController
      before_action :require_login
      before_action :get_jira_client
      before_action :set_project, only: [:show, :update, :destroy]

      # GET /projects
      def index
        projects = @jira_client.Project.all
        items = []
        projects.each do |project|
          items.push(project.attrs)
          @projects = items
        end

        render json: @projects
      end

      # Get /project
      def show
        if params[:key]
          project = @jira_client.Project.find(params[:key])
          @item = project.attrs
          
          items = []
          project.issues.each do |issue|
            items.push(issue.attrs)
            @issues = items
          end
        begin
          rescue JIRA::HTTPError => e
            puts e.response.code
            puts e.response.message
            puts e.response.body  
        end          
          render :json => {:project => @item, :issues => @issues}.to_json
        else 
          render :json => {:error => "You need to provide a key for the project"}.to_json
        end
      end

      # POST /projects
      def create
        client = @jira_client
        project = client.Project.build
        projectKey = params[:project_key]
        projectType = params[:project_type]
        projectName = params[:name]
        projectDescription = params[:description]

        begin
          project.save!({"key" => projectKey, "name" => projectName, "projectTypeKey" => projectType, "description" => projectDescription, "lead" => current_user.name })
        rescue JIRA::HTTPError => e
          puts e.response.code
          puts e.response.message
          puts e.response.body  
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