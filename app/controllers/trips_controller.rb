
class TripsController < ApplicationController
    def index
        if params[:passenger_id]

            passenger = Passenger.find_by(id: params[:passenger_id])
            if passenger
              @trips = passenger.trips
            else
              head :not_found
              return
            end
          else
            @trips = Trip.all
          end
    end

    def new
        if params[:passenger_id]
            @passenger = Passenger.find_by(id: params[:passenger_id])
            if @passenger
              @trip = @passenger.trips.new
            else
              head :not_found
              return
            end
          else
            @trip = Trip.new
          end
    end

    def create
        
        @trip = Trip.new(trip_params)
        
        successful = @trip.save!
        if successful
            redirect_to trip_path(@trip.id)
        else 
            render :new, status: :bad_request
        end
    end

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
        return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id,)
    end
end