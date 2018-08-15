module Api
  module V1
    
    class UsersController < ApiController
      
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :require_login, only: [:show, :index, :update, :destroy]
      
        def new
          @user = User.new
        end
        
        
        # GET /user/:id
        def show
          render json: @user
        end

        def index 
          @users = User.all

          render json: @users
        end
      
        def create
          @user = User.new(user_params)
          if @user.save
            render json: @user, :except=>  [:password_digest, :token_created_at]
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end

        # PATCH/PUT /trips/1
        def update
          if @user.update(user_params)
            render json: @user, :except=>  [:password_digest, :token_created_at]
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end

        # DELETE /trips/1
        def destroy
          @user.destroy
        end
      
        private
        
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        def user_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
    end
  end
end