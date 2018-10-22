module Api
  module V1
    
    class UsersController < ApiController
      
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :require_login, only: [:show, :index, :update, :create_admin, :destroy]

      swagger_controller :users, "User Management"
      
        def new
          @user = User.new
        end
        
        swagger_api :show do
          summary "Fetches a single User item"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :id, :integer, :optional, "User Id"
          response :ok, "Success", :User
          response :unauthorized
          response :unprocessable_entity
          response :forbidden
          response :not_found
        end
        
        # GET /user/:id
        def show
          
          user = User.find(params[:id])
          if current_user.id == user.id
            render json: @user
          else 
            authorize! :read, @user

            render json: @user
          end
        end

        swagger_api :index do
          summary "Fetches all User "
          notes "This lists all the active users. Only users with admin access have the rights to view this endpoint. eg http://localhost:3000/api/v1/users?page=1&per_page=2"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :query, :page, :integer, :optional, "Page number"
          param :query, :per_page, :integer, :optional, "Per page option"
          response :ok
          response :unauthorized
          response :forbidden
        end
      

        def index

          @user = current_user
          authorize! :read, @user

          @users = User.all

          if params[:page]

            paginate json: @users, meta: {
              total: @users.count,
              per_page: params[:per_page].to_i, 
              page: params[:page].to_i, 
              pages: (@users.count / params[:per_page].to_f).ceil
            }
          else
            render json: @users
          end

        end

        swagger_api :create do
          summary "Creates a new User"
          param :form, "user[name]", :string, :required, "Name"
          param :form, "user[email]", :string, :required, "Email address"
          param :form, "user[password]", :string, :required, "Password"
          param :form, "user[password_confirmation]", :string, :required, "Password Confirmation"
          response :created
          response :unauthorized
          response :unprocessable_entity
        end
      
        def create
          @user = User.new(user_params)
      
          if @user.save
            # Send a welcome email 
            NotificationsMailer.welcome(@user).deliver
            render json: @user, :except=>  [:password_digest, :token_created_at, :reset_password_token, :reset_password_sent_at]
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end


        swagger_api :update do
          summary "Updates an existing User"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :id, :integer, :required, "User Id"
          param :form, "user[name]", :string, :required, "Name"
          param :form, "user[email]", :string, :required, "Email address"
          param :form, "user[password]", :string, :required, "Password"
          param :form, "user[password_confirmation]", :string, :required, "Password Confirmation"
          response :ok
          response :unauthorized
          response :not_found
          response :unprocessable_entity
          response :forbidden
        end

        # PATCH/PUT /users/1
        def update
          authorize! :update, @user
          if @user.update(user_params)
            
            render json: @user, :except=>  [:password_digest, :token_created_at]
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end


        swagger_api :destroy do
          summary "Deletes an existing User item"
          param :header, :Authorization, :string, :required, "To authorize the requests."
          param :path, :id, :integer, :optional, "User Id"
          response :ok
          response :unauthorized
          response :forbidden
          response :not_found
        end

        # DELETE /users/1
        def destroy
          authorize! :destroy, @user
          @user.destroy
        end
      
        private
        
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation, :jira_token)
        end

    end
  end
end