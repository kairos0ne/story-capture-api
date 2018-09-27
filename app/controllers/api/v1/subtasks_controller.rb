module Api
  module V1
    class SubtasksController < ApiController
      before_action :require_login
      before_action :set_subtask, only: [:show, :update, :destroy]

      swagger_controller :subtasks, "Subtask Management"

      swagger_api :index do
        summary "Fetches all Subtasks for an Story "
        param :header, :Authorization, :string, :required, "To authorize the requests."
        param :path, :user_id, :integer, :required, "User Id"
        param :path, :client_id, :integer, :required, "Client Id"
        param :path, :epic_id, :integer, :required, "Epic Id"
        param :path, :story_id, :integer, :required, "Story Id"
        param :query, :page, :integer, :optional, "Page number"
        param :query, :per_page, :integer, :optional, "Per page option"
        response :ok
        response :unauthorized
        response :forbidden
      end

      # GET /subtasks
      def index
        # get the user from params 
        user = User.find(params[:user_id])
        if current_user.admin == true
          client = Client.find(params[:client_id])
          epic = Epic.find(params[:epic_id])
          story = Story.find(params[:story_id])
          @subtasks = story.subtask.all
          # If the params contain 'page'
          if params[:page] && params[:per_page]
            # Paginate the results  
            paginate json: @subtasks, meta: {
              total: @subtasks.count,
              per_page: params[:per_page].to_i, 
              page: params[:page].to_i,
              pages: (@subtasks.count / params[:per_page].to_f).ceil
            }
          # Else render the full json   
          else
            render json: @subtasks
          end
        # Check that the current user matches the user from the URL 
        elsif current_user.id == user.id 
          # get the clients for a user
          client = Client.find(params[:client_id])
          epic = Epic.find(params[:epic_id])
          story = Story.find(params[:story_id])
          @subtasks = story.subtask.all
          # If the params contain 'page'
          if params[:page] && params[:per_page]
            # Paginate the results  
            paginate json: @subtasks, meta: {
              total: @subtasks.count,
              per_page: params[:per_page].to_i, 
              page: params[:page].to_i,
              pages: (@subtasks.count / params[:per_page].to_f).ceil
            }
          # Else render the full json   
          else
            render json: @subtasks
          end
        else
          render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json, :status => :forbidden
        end
      end

      swagger_api :show do
        summary "Fetches a single Subtask for a Story "
        param :header, :Authorization, :string, :required, "To authorize the requests."
        param :path, :user_id, :integer, :required, "User Id"
        param :path, :client_id, :integer, :required, "Client Id"
        param :path, :epic_id, :integer, :required, "Epic Id"
        param :path, :story_id, :integer, :required, "Story Id"
        param :path, :id, :integer, :required, "Subtask Id"
        response :ok
        response :unauthorized
        response :forbidden
      end

      # GET /subtasks/1
      def show
        user = User.find(params[:user_id])
        if current_user.admin = true
          render json: @subtask
        elsif current_user.id == user.id 
          render json: @subtask
        else
          render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json, :status => :forbidden
        end
      end

      swagger_api :create do
        summary "Creates a new Subtask"
        param :header, :Authorization, :string, :required, "To authorize the requests."
        param :path, :user_id, :integer, :required, "User Id"
        param :path, :client_id, :integer, :required, "Client Id"
        param :path, :epic_id, :integer, :required, "Epic Id"
        param :path, :story_id, :integer, :required, "Story Id"
        param :form, "story[task]", :string, :required, "Name"
        param :form, "story[task_type]", :string, :optional, "Type"
        param :form, "story[points]", :string, :optional, "Points"
        response :created
        response :unauthorized
        response :unprocessable_entity
      end

      # POST /subtasks
      def create
        @subtask = Subtask.new(subtask_params)

        if @subtask.save
          render json: @subtask, status: :created
        else
          render json: @subtask.errors, status: :unprocessable_entity
        end
      end

      swagger_api :update do
        summary "Update a Subtask"
        param :header, :Authorization, :string, :required, "To authorize the requests."
        param :path, :user_id, :integer, :required, "User Id"
        param :path, :client_id, :integer, :required, "Client Id"
        param :path, :epic_id, :integer, :required, "Epic Id"
        param :path, :story_id, :integer, :required, "Story Id"
        param :path, :id, :integer, :required, "Subtask Id"
        param :form, "story[task]", :string, :required, "Name"
        param :form, "story[task_type]", :string, :optional, "Type"
        param :form, "story[points]", :string, :optional, "Points"
        response :created
        response :unauthorized
        response :unprocessable_entity
      end
    
      # PATCH/PUT /subtasks/1
      def update
        if @subtask.update(subtask_params)
          render json: @subtask
        else
          render json: @subtask.errors, status: :unprocessable_entity
        end
      end

      swagger_api :destroy do
        summary "Deletes an existing Subtask item"
        param :header, :Authorization, :string, :required, "To authorize the requests."
        param :path, :user_id, :integer, :required, "User Id"
        param :path, :client_id, :integer, :require, "Client Id"
        param :path, :epic_id, :integer, :required, "Epic Id"
        param :path, :story_id, :integer, :required, "Story Id"
        param :path, :id, :integer, :required, "Subtask Id"
        response :ok
        response :unauthorized
        response :forbidden
        response :not_found
      end

      # DELETE /subtasks/1
      def destroy
        @subtask.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_subtask
          @subtask = Subtask.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def subtask_params
          params.require(:subtask).permit(:task, :task_type, :points, :story_id)
        end
    end
  end
end