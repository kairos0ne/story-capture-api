module Api
  module V1
      class ClientsController < ApiController
        before_action :require_login
        before_action :set_client, only: [:show, :update, :destroy]

        swagger_controller :clients, "Clients Management"

        swagger_api :index do
          summary "Fetches all Clients for a user "
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :query, :page, :integer, :optional, "Page number"
          param :query, :per_page, :integer, :optional, "Per page option"
          response :ok
          response :unauthorized
          response :forbidden
        end


        # GET /clients
        def index
        
          # get the user from params 
          user = User.find(params[:user_id])
          if current_user.admin == true
            @clients = user.client.all
            # If the params contain 'page'
            if params[:page] && params[:per_page]
              # Paginate the results  
              paginate json: @clients, meta: {
                total: @clients.count,
                per_page: params[:per_page].to_i, 
                page: params[:page].to_i,
                pages: (@clients.count / params[:per_page].to_f).ceil
              }
            # Else render the full json   
            else
              render json: @clients
            end
          # Check that the current user matches the user from the URL 
          elsif current_user.id == user.id 
            # get the clients for a user
            @clients = user.client.all
            if params[:page] && params[:per_page]
              # Paginate the results  
              paginate json: @clients, meta: {
                total: @clients.count,
                per_page: params[:per_page].to_i, 
                page: params[:page].to_i,
                pages: (@clients.count / params[:per_page].to_f).ceil
              }
            # Else render the full json   
            else
              render json: @clients
            end
          else
            render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json, :status => :forbidden
          end
        end

        swagger_api :show do
          summary "Fetches a single Client item"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :id, :integer, :require, "Client Id"
          response :ok, "Success", :User
          response :unauthorized
          response :unprocessable_entity
          response :forbidden
          response :not_found
        end

        # GET users/1/clients/1
        def show
          user = User.find(params[:user_id])
          if current_user.admin = true
            render json: @client
          elsif current_user.id == user.id 
            render json: @client
          else
            render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json, :status => :forbidden
          end
        end

        swagger_api :create do
          summary "Creates a new Client"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :form, "client[name]", :string, :required, "Name"
          param :form, "client[description]", :string, :optional, "Description"
          response :created
          response :unauthorized
          response :unprocessable_entity
        end

        # POST /clients
        def create
          @client = Client.new(client_params)
          if @client.save
            render json: @client, status: :created
          else
            render json: @client.errors, status: :unprocessable_entity
          end
        end


        swagger_api :update do
          summary "Updates a Client"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :id, :integer, :require, "Client Id"
          param :form, "client[name]", :string, :optional, "Name"
          param :form, "client[description]", :string, :optional, "Description"
          response :created
          response :unauthorized
          response :unprocessable_entity
        end

        # PATCH/PUT /clients/1
        def update
          if @client.update(client_params)
            render json: @client
          else
            render json: @client.errors, status: :unprocessable_entity
          end
        end

        swagger_api :destroy do
          summary "Deletes an existing Client item"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :user_id, :integer, :required, "User Id"
          param :path, :id, :integer, :require, "Client Id"
          response :ok
          response :unauthorized
          response :forbidden
          response :not_found
        end

        # DELETE /clients/1
        def destroy
          @client.destroy
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_client
            @client = Client.find(params[:id])
          end

          # Only allow a trusted parameter "white list" through.
          def client_params
            params.require(:client).permit(:name, :description, :user_id)
          end
      end
  end
end
