class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all.where(deleted: nil)
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

    passenger.deleted = !passenger.deleted

    passenger.save

    redirect_to passengers_path
  end

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
