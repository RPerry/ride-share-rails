class DriversController < ApplicationController
    def index
        @drivers = Driver.all
    end

    def new
        @driver = Driver.new
    end

    def create
        @driver = Driver.new(driver_params)
        
        successful = @driver.save

        if successful
            redirect_to driver_path(driver.id)
        else 
            render :new
        end

        # unless params["driver"]
        #     render :new, status: :bad_request
        #     return
        # end
        
        # driver.save
        
       
    end

    def show
        driver_id = params[:id]
        @driver = Driver.find_by(id: driver_id)

        if @driver.nil?
            redirect_to drivers_path
        end

    end

    def edit
        driver_id = params[:id]
        @driver = Driver.find_by(id: driver_id)

        if @driver.nil?
            redirect_to drivers_path
        end
    end

    def update
        driver_id = params[:id]
        driver = Driver.find_by(id: driver_id)

        if driver.nil?
            redirect_to drivers_path
            return
        end

        driver.update(driver_params)

        redirect_to driver_path(driver.id)
    end

    def destroy
        driver_id = params[:id]

        driver = Driver.find_by(id: driver_id)

       unless driver
        head :not_found
        return
       end

        driver.destroy
        
        redirect_to drivers_path
    end

    private

    def driver_params
        return params.require(:driver).permit(:name, :vin, :car_make, :car_model)
    end
end
