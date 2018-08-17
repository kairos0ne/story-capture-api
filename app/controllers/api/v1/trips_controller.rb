module Api
  module V1

    class TripsController < ApiController
    before_action :require_login
    before_action :set_trip, only: [:show, :update, :destroy]

    # GET /trips
    def index 
      # get the user from params 
      user = User.find(params[:user_id])
      # check if the current user is an admin 
      if current_user.admin == true
        @trips = user.trip.all
        # Check if the the params contains pagination 
        if params[:page]
          paginate json: @trips, meta: {
            total: @trips.count,
            per_page: params[:per_page], 
            page: params[:page] 
          }
        else 
          # Render json response for all trips  
          render json: @trips
        end
       # Check is the user is current user if not render unathorised 
      elsif current_user.id == user.id
        @trips = user.trip.all
        if params[:page]
          paginate json: @trips, meta: {
            total: @trips.count,
            per_page: params[:per_page], 
            page: params[:page] 
          }
        else
          render json: @trips
        end
      else 
        render :json => {:error => "You don't have permissions to visit this endpoint"}.to_json
      end
    end

    # GET /trips/1
    def show
      authorize! :read, @trip
      render json: @trip
    end

    # POST /trips
    def create
      @trip = Trip.new(trip_params)

      if @trip.save
        authorize! :create, @trip
        render json: @trip, status: :created
      else
        render json: @trip.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if @trip.update(trip_params)
        authorize! :update, @trip
        render json: @trip
      else
        render json: @trip.errors, status: :unprocessable_entity
      end
    end

    # DELETE /trips/1
    def destroy
      authorize! :destroy, @trip
      @trip.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_trip
        @trip = Trip.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def trip_params
        params.require(:trip).permit(:start_date, :end_date, :destination, :departure_airport_code, :arrival_airport_code, :departure_time, :arrival_time, :user_id)
      end
    end
  end
end
