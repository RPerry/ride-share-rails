require "test_helper"

describe "TripsController" do
  let (:trip) {
    Trip.create date: '2016-12-12', cost: 1234.5
  }

  let (:driver) {
    Driver.create(name: "Jessica Sanchez", vin: "L1CDHZJ0567RJKCJ6", available: true)
}

  let (:passenger) {
    Passenger.create name: "John Randall", phone_num: "234-456-3454"
  }

  describe "show" do
    it "can get a valid trip" do
      trip = Trip.new(date: '2016-12-12', passenger_id: passenger.id, driver_id: driver.id)
      trip.save!
      get trip_path(trip.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid driver" do
      # Act
      get trip_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "can get the edit page for an existing trip" do
      # Act
      trip = Trip.new(date: '2016-12-12', passenger_id: passenger.id, driver_id: driver.id)
      trip.rating = 4.0
      trip.save!

      get edit_trip_path(trip.id)

      # Assert
      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a nonexistant trip" do
      get edit_trip_path(999)

      must_respond_with :redirect
      must_redirect_to trips_path
    end
  end

  describe "update" do
    
    it "can update an existing trip" do
      trip = Trip.new(date: '2016-12-12', passenger_id: passenger.id, driver_id: driver.id)
      trip.rating = 4.0
      trip.save!
      
      trip_hash = {
        trip: {
          date: Date.today,
          rating: 4.0,
          cost: 1474.0
        },
      }

      expect {
        patch trip_path(trip.id), params: trip_hash
      }.must_change "Trip.count", 0

      #Repulling from database - updating the date variable
      trip.reload
      expect(trip.date).must_equal trip_hash[:trip][:date]
      expect(trip.rating).must_equal trip_hash[:trip][:rating]
      expect(trip.cost).must_equal trip_hash[:trip][:cost]
      

      must_respond_with :redirect
      must_redirect_to trip_path(trip.id)
    end

    it "will redirect to the root page if given an invalid id" do
        patch trip_path(999)
        must_respond_with :redirect
        must_redirect_to trips_path
    end

    it "will toggle driver availability back to true after rating the driver" do

    end
  end

  describe "new" do
    it "can get the new trip page" do

      get new_trip_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new trip" do
      Driver.create(name: "Jessica Sanchez", vin: "L1CDHZJ0567RJKCJ6", available: true)
      expect {
        post passenger_trips_path(passenger)
      }.must_change "Trip.count", +1
  
      expect(Trip.all.last.passenger).must_equal passenger
      
      must_respond_with :redirect
      must_redirect_to trip_path(Trip.all.last.id)
    end

    it "doesn't create a trip if there are no available drivers" do
      
      expect {
        post passenger_trips_path(passenger)
      }.wont_change "Trip.count"

      must_respond_with :bad_request
    end
  end


  describe "destroy" do
    it "removes the trip from the database" do
      trip = Trip.create(passenger_id: passenger.id, driver_id: driver.id, date: '2016-12-12')
      trip.rating = 4.0
      
      expect {
        delete trip_path(trip)
      }.must_change "Trip.count", -1

      must_respond_with :redirect
      must_redirect_to trips_path

      after_trip = Trip.find_by(id: trip.id)
      expect(after_trip).must_be_nil
    end

    it "returns a 404 if the trip does not exist" do
      trip_id = 999

      expect(Trip.find_by(id: trip_id)).must_be_nil

      expect {
        delete trip_path(trip_id)
      }.wont_change "Trip.count"

      must_respond_with :not_found
    end
  end
end
