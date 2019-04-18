class PassengersController < ApplicationController
  def index
    # Load a list of passengers from somewhere
    @passengers = Passenger.all

    @featured_passenger = @passengers.sample
  end

  def new
    @passenger = Passenger.new
  end

  def create
    @passenger = Passenger.new(passenger_params)

    successful = @passenger.save
    if successful
      redirect_to passengers_path
    else
      render :new, status: :bad_request
    end
  end

  def show
    passenger_id = params[:id]

    @passenger = Passenger.find_by(id: passenger_id)

    @is_driver_available = !Driver.first_available_driver.nil?

    unless @passenger
      head :not_found
    end
  end

  def edit
    passenger_id = params[:id]

    @passenger = Passenger.find_by(id: passenger_id)

    unless @passenger
      head :not_found
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])

    unless @passenger
      head :not_found
      return
    end

    if @passenger.update(passenger_params)
      redirect_to passenger_path(@passenger)
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    passenger_id = params[:id]

    passenger = Passenger.find_by(id: passenger_id)

    unless passenger
      head :not_found
      return
    end

    # driver.trips.all.each do |t|
    #   t.driver_id = 99999
    #  end

    passenger.destroy

    redirect_to passengers_path
  end

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
