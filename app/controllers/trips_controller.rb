class TripsController < ApplicationController
    def index
        @trips = Trip.all
    end

    # def new
    #     @trip = Trip.new
    # end

    # def create
    #     @trip = Trip.new(trip_params)
        
    #     successful = @trip.save

    #     if successful
    #         redirect_to trip_path(trip.id)
    #     else 
    #         render :new
    #     end
    # end

    def show
        trip_id = params[:id]
        @trip = Trip.find_by(id: trip_id)

        if @trip.nil?
            redirect_to trips_path
        end

    end

    def edit
        trip_id = params[:id]
        @trip = Trip.find_by(id: trip_id)

        if @trip.nil?
            redirect_to trips_path
        end
    end

    def update
        trip_id = params[:id]
        trip = Trip.find_by(id: trip_id)

        if trip.nil?
            redirect_to trips_path
            return
        end

        trip.update(trip_params)

        redirect_to trip_path(trip.id)
    end

    def destroy
        trip_id = params[:id]

        trip = Trip.find_by(id: trip_id)

        unless trip
        head :not_found
        return
        end

        trip.destroy
        
        redirect_to trips_path
    end

    private

    def trip_params
        return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id)
    end
end