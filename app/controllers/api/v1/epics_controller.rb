
module Api
  module V1
      class EpicsController < ApiController
        before_action :require_login
        before_action :set_epic, only: [:show, :update, :destroy]


        swagger_controller :epics, "Epics Management"

        swagger_api :index do
          summary "Fetches all Epics for a user "
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :required, "Client Id"
          param :query, :page, :integer, :optional, "Page number"
          param :query, :per_page, :integer, :optional, "Per page option"
          response :ok
          response :unauthorized
          response :forbidden
        end

        # GET /epics
        def index
        
          # get the user from params 
          user = User.find(params[:user_id])
          if current_user.admin == true
            client = Client.find(params[:client_id])
            @epics = client.epic.all
            # If the params contain 'page'
            if params[:page] && params[:per_page]
              # Paginate the results  
              paginate json: @epics, meta: {
                total: @epics.count,
                per_page: params[:per_page].to_i, 
                page: params[:page].to_i,
                pages: (@epics.count / params[:per_page].to_f).ceil
              }
            # Else render the full json   
            else
              render json: @epics
            end
          # Check that the current user matches the user from the URL 
          elsif current_user.id == user.id 
            # get the clients for a user
            client = Client.find(params[:client_id])
            @epics = client.epic.all
            # If the params contain 'page'
            if params[:page] && params[:per_page]
              # Paginate the results  
              paginate json: @epics, meta: {
                total: @epics.count,
                per_page: params[:per_page].to_i, 
                page: params[:page].to_i,
                pages: (@epics.count / params[:per_page].to_f).ceil
              }
            # Else render the full json   
            else
              render json: @epics
            end
          else
            render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json, :status => :forbidden
          end
        end

        swagger_api :show do
          summary "Fetches a single Epic for a client "
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :required, "Client Id"
          param :path, :id, :integer, :required, "Epic Id"
          response :ok
          response :unauthorized
          response :forbidden
        end

        # GET clients/1/epics/1
        def show
          user = User.find(params[:user_id])
          if current_user.admin = true
            render json: @epic
          elsif current_user.id == user.id 
            render json: @epic
          else
            render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json, :status => :forbidden
          end
        end

        swagger_api :create do
          summary "Creates a new Epic"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :required, "Client Id"
          param :form, "epic[name]", :string, :required, "Name"
          param :form, "epic[summary]", :string, :optional, "Name"
          response :created
          response :unauthorized
          response :unprocessable_entity
        end

        # POST /epics
        def create
          @epic = Epic.new(epic_params)

          if @epic.save
            render json: @epic, status: :created
          else
            render json: @epic.errors, status: :unprocessable_entity
          end
        end

        swagger_api :update do
          summary "Updates an Epic"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :required, "Client Id"
          param :path, :id, :integer, :required, "Epic Id"
          param :form, "epic[name]", :string, :required, "Name"
          param :form, "epic[summary]", :string, :optional, "Name"
          response :created
          response :unauthorized
          response :unprocessable_entity
        end

        # PATCH/PUT /epics/1
        def update
          if @epic.update(epic_params)
            render json: @epic
          else
            render json: @epic.errors, status: :unprocessable_entity
          end
        end

        swagger_api :destroy do
          summary "Deletes an existing Epic item"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :client_id, :integer, :require, "Client Id"
          param :path, :id, :integer, :required, "Epic Id"
          response :ok
          response :unauthorized
          response :forbidden
          response :not_found
        end

        # DELETE /epics/1
        def destroy
          @epic.destroy
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_epic
            @epic = Epic.find(params[:id])
          end

          # Only allow a trusted parameter "white list" through.
          def epic_params
            params.require(:epic).permit(:name, :summary, :client_id)
          end
      end
  end
end
