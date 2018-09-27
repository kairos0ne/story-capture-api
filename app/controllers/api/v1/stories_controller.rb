module Api
  module V1
      class StoriesController < ApiController
        before_action :require_login
        before_action :set_story, only: [:show, :update, :destroy]

        swagger_controller :stories, "Story Management"

        swagger_api :index do
          summary "Fetches all Stories for an Epic "
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :required, "Client Id"
          param :path, :epic_id, :integer, :required, "Epic Id"
          param :query, :page, :integer, :optional, "Page number"
          param :query, :per_page, :integer, :optional, "Per page option"
          response :ok
          response :unauthorized
          response :forbidden
        end

        # GET /stories
        def index
        
          # get the user from params 
          user = User.find(params[:user_id])
          if current_user.admin == true
            client = Client.find(params[:client_id])
            epic = Epic.find(params[:epic_id])
            @stories = epic.story.all
            # If the params contain 'page'
            if params[:page] && params[:per_page]
              # Paginate the results  
              paginate json: @stories, meta: {
                total: @stories.count,
                per_page: params[:per_page].to_i, 
                page: params[:page].to_i,
                pages: (@stories.count / params[:per_page].to_f).ceil
              }
            # Else render the full json   
            else
              render json: @stories
            end
          # Check that the current user matches the user from the URL 
          elsif current_user.id == user.id 
            # get the clients for a user
            client = Client.find(params[:client_id])
            epic = Epic.find(params[:epic_id])
            @stories = epic.story.all
            # If the params contain 'page'
            if params[:page] && params[:per_page]
              # Paginate the results  
              paginate json: @stories, meta: {
                total: @stories.count,
                per_page: params[:per_page].to_i, 
                page: params[:page].to_i,
                pages: (@stories.count / params[:per_page].to_f).ceil
              }
            # Else render the full json   
            else
              render json: @stories
            end
          else
            render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json, :status => :forbidden
          end
        end

        swagger_api :show do
          summary "Fetches a single Story for a Epic "
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :required, "Client Id"
          param :path, :epic_id, :integer, :required, "Epic Id"
          param :path, :id, :integer, :required, "Story Id"
          response :ok
          response :unauthorized
          response :forbidden
        end

        # GET /stories/1
        def show
          user = User.find(params[:user_id])
          if current_user.admin = true
            render json: @story
          elsif current_user.id == user.id 
            render json: @story
          else
            render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json, :status => :forbidden
          end
        end

        swagger_api :create do
          summary "Creates a new Story"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :required, "Client Id"
          param :path, :epic_id, :integer, :required, "Epic Id"
          param :form, "story[task]", :string, :required, "Name"
          param :form, "story[story_type]", :string, :optional, "Type"
          param :form, "story[points]", :string, :optional, "Points"
          response :created
          response :unauthorized
          response :unprocessable_entity
        end

        # POST /stories
        def create
          @story = Story.new(story_params)

          if @story.save
            render json: @story, status: :created
          else
            render json: @story.errors, status: :unprocessable_entity
          end
        end

        swagger_api :update do
          summary "Updates a Story"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :required, "Client Id"
          param :path, :epic_id, :integer, :required, "Epic Id"
          param :path, :id, :integer, :required, "Story Id"
          param :form, "story[task]", :string, :required, "Name"
          param :form, "story[story_type]", :string, :optional, "Type"
          param :form, "story[points]", :string, :optional, "Points"
          response :created
          response :unauthorized
          response :unprocessable_entity
        end

        # PATCH/PUT /stories/1
        def update
          if @story.update(story_params)
            render json: @story
          else
            render json: @story.errors, status: :unprocessable_entity
          end
        end

        swagger_api :destroy do
          summary "Deletes an existing Story item"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :require, "Client Id"
          param :path, :epic_id, :integer, :required, "Epic Id"
          param :path, :id, :integer, :required, "Story Id"
          response :ok
          response :unauthorized
          response :forbidden
          response :not_found
        end

        # DELETE /stories/1
        def destroy
          @story.destroy
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_story
            @story = Story.find(params[:id])
          end

          # Only allow a trusted parameter "white list" through.
          def story_params
            params.require(:story).permit(:task, :story_type, :points, :epic_id)
          end
      end
    end
  end
