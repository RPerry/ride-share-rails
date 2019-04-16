require "test_helper"

describe "TripsController" do
  let (:trip) {
    Trip.create driver_id: 0, passenger_id: 0, date: 0000-00-01, rating: 0.0, cost: 1234.5
  }

  # describe "index" do
  #   it "can get index" do
  #     get trips_path

  #     must_respond_with :success
  #   end
  # end

  describe "show" do
    it "can get a valid trip" do
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
      trip = Trip.new
      trip.rating = 4.0
      trip.save

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
      trip = Trip.new
      trip.rating = 4.0
      trip.save
      
      trip_hash = {
        trip: {
          date: 2016-06-02,
          rating: 4.0,
          cost: 1474.0,
          driver_id: 1,
          passenger_id: 1,
        },
      }

      expect {
        patch trip_path(trip.id), params: trip_hash
      }.must_change "Trip.count", 0

      expect(trip.date).must_equal 2016-06-02
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
  end

  # describe "new" do
  #   it "can get the new trip page" do

  #     get new_trip_path

  #     must_respond_with :success
  #   end
  # end

  # describe "create" do
  #   it "can create a new trip" do

  #     trip_hash = {
  #       trip: {
  #         date: 2016-06-02,
  #         rating: 4.0,
  #         cost: 1474.0,
  #       },
  #     }

  #     # Act-Assert
  #     expect {
  #       post trips_path, params: trip_hash
  #     }.must_change "Trip.count", 1

  #     new_trip = Trip.find_by(date: trip_hash[:trip][:date])
  #     expect(trip.date).must_equal trip_hash[:trip][:date]
  #     expect(trip.rating).must_equal trip_hash[:trip][:rating]
  #     expect(trip.cost).must_equal trip_hash[:trip][:cost]

  #     must_respond_with :redirect
  #     must_redirect_to trip_path(new_trip.id)
  #   end
  # end

  describe "destroy" do
    it "removes the trip from the database" do
      trip = Trip.create(date: 2016-06-02)
      
      expect {
        delete trip_path(trip)
      }.must_change "Trip.count", -1

      must_respond_with :redirect
      must_redirect_to trips_path

      after_trip = Trip.find_by(date: trip.id)
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
