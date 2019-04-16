require "test_helper"

describe "DriversController" do
  let (:driver) {
    Driver.create name: "name", vin: "123456789", car_make: "make", car_model: "model"
  }
  
  describe "index" do
    it "can get index" do
      get drivers_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "can get a valid driver" do
      get driver_path(driver.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid driver" do
      # Act
      get driver_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "can get the edit page for an existing driver" do
      # Act
      driver = Driver.new
      driver.name = "John Randall"
      driver.save

      get edit_driver_path(driver.id)

      # Assert
      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a nonexistant driver" do
      get edit_driver_path(999)

      must_respond_with :redirect
      must_redirect_to drivers_path
    end
  end

  describe "update" do
    it "can update an existing driver" do
      driver = Driver.new
      driver.name = "John Randall"
      driver.save
      
      driver_hash = {
        driver: {
          name: "John Randall",
          vin: "123456789",
          car_make: "Honda",
          car_model: "Accord"
        },
      }

      # Act-Assert
      expect {
        patch driver_path(driver.id), params: driver_hash
      }.must_change "Driver.count", 0

      expect(driver.name).must_equal "John Randall"
      #Repulling from database - updating the title variable
      driver.reload
      expect(driver.name).must_equal driver_hash[:driver][:name]
      expect(driver.vin).must_equal driver_hash[:driver][:vin]
      expect(driver.car_make).must_equal driver_hash[:driver][:car_make]
      expect(driver.car_model).must_equal driver_hash[:driver][:car_model]

      must_respond_with :redirect
      must_redirect_to driver_path(driver.id)
    end

    it "will redirect to the root page if given an invalid id" do
        patch driver_path(999)
        must_respond_with :redirect
        must_redirect_to drivers_path
    end
  end

  describe "new" do
    it "can get the new driver page" do

      get new_driver_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver" do

      driver_hash = {
        driver: {
          name: "John Randall",
          vin: "123456789",
          car_make: "Honda",
          car_model: "Accord"
        },
      }

      # Act-Assert
      expect {
        post drivers_path, params: driver_hash
      }.must_change "Driver.count", 1

      new_driver = Driver.find_by(name: driver_hash[:driver][:name])
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]
      expect(new_driver.car_make).must_equal driver_hash[:driver][:car_make]
      expect(new_driver.car_model).must_equal driver_hash[:driver][:car_model]

      must_respond_with :redirect
      must_redirect_to driver_path(new_driver.id)
    end
  end

  describe "destroy" do
    it "removes the driver from the database" do
      driver = Driver.create(name: "John Randall")
      
      expect {
        delete driver_path(driver)
      }.must_change "Driver.count", -1

      must_respond_with :redirect
      must_redirect_to drivers_path

      after_driver = Driver.find_by(name: driver.id)
      expect(after_driver).must_be_nil
    end

    it "returns a 404 if the driver does not exist" do
      driver_id = 999

      expect(Driver.find_by(name: driver_id)).must_be_nil

      expect {
        delete driver_path(driver_id)
      }.wont_change "Driver.count"

      must_respond_with :not_found
    end
  end
end
