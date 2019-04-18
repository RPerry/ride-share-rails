require "test_helper"

describe "PassengersController" do
  let (:passenger) {
    Passenger.create name: "Bob", phone_num: 9999999999
  }

  describe "index" do
    it "renders without crashing" do
      # Arrange

      # Act
      get passengers_path

      # Assert
      must_respond_with :ok
    end

    it "renders even if there is zero passenger" do
      # Arrange
      Passenger.destroy_all

      # Act
      get passengers_path

      # Assertm
      must_respond_with :ok

    end
  end

  describe "show" do
    it "works for a passenger that exists" do
      # Arrange

      # Act
      get passenger_path(passenger.id)

      # Assert
      must_respond_with :ok
    end

    it "returns a 404 status code if the passenger doesn't exist" do
      # Arrange
      passenger_id = 1337

      # Act
      get passenger_path(passenger_id)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "edit" do
    it "responds with OK for a real passenger" do
      get edit_passenger_path(passenger)
      must_respond_with :ok
    end

    it "responds with not_found for a passenger that doesn't exist" do
      passenger_id = -1
      get edit_passenger_path(passenger_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    let(:passenger_data) {
      {
        passenger: {
          name: "changed name",
        },
      }
    }

    it "changes the data on the model" do
      test_passenger = passenger
      # Assumptions
      test_passenger.assign_attributes(passenger_data[:passenger])
      expect(test_passenger).must_be :valid?
      test_passenger.reload

      # Act
      patch passenger_path(test_passenger), params: passenger_data

      # Assert
      must_respond_with :redirect
      must_redirect_to passenger_path(test_passenger)
      
      test_passenger.reload
      expect(test_passenger.name).must_equal(passenger_data[:passenger][:name])
    end

    it "responds with bad_request for bad data" do
      test_passenger = passenger
      # Arrange
      passenger_data[:passenger][:name] = ""

      # Assumptions
      test_passenger.assign_attributes(passenger_data[:passenger])
      expect(test_passenger).wont_be :valid?
      test_passenger.reload

      # Act
      patch passenger_path(test_passenger), params: passenger_data

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "new" do
    it "returns status code 200" do
      # Arrange

      # Act
      get new_passenger_path

      # Assert
      must_respond_with :ok
    end
  end

  describe "create" do
    it "can create a new passenger" do
      # Arrange
      passenger_data = {
        passenger: {
          name: "Bob",
          phone_num: "9999999999",
        },
      }

      # Act
      expect {
        post passengers_path, params: passenger_data
      }.must_change "Passenger.count", +1

      # Assert
      must_respond_with :redirect
      must_redirect_to  passengers_path

      passenger = Passenger.last
      expect(passenger.name).must_equal passenger_data[:passenger][:name]
      expect(passenger.phone_num).must_equal passenger_data[:passenger][:phone_num]
    end

    it "sends back bad_request if no passenger data is sent" do
      # Arrange
      passenger_data = {
        passenger: {
          name: "",
        },
      }
      expect(Passenger.new(passenger_data[:passenger])).wont_be :valid?

      # Act
      expect {
        post passengers_path, params: passenger_data
      }.wont_change "Passenger.count"

      # Assert
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "removes the passenger from the database" do
      test_passenger = passenger

      # Act
      expect {
        delete passenger_path(test_passenger)
      }.must_change "Passenger.count", -1

      # Assert
      must_respond_with :redirect
      must_redirect_to passengers_path

      after_passenger = Passenger.find_by(id: test_passenger.id)
      expect(after_passenger).must_be_nil
    end

    it "returns a 404 if the book does not exist" do
      # Arrange
      passenger_id = 1337

      # Assumptions
      expect(Passenger.find_by(id: passenger_id)).must_be_nil

      # Act
      expect {
        delete passenger_path(passenger_id)
      }.wont_change "Passenger.count"

      # Assert
      must_respond_with :not_found
    end
  end
end
