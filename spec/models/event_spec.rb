require "rails_helper"

RSpec.describe Event, type: :model do
  it "is invalid when start time is after end time" do
    event = Event.new(
      title: "Cleanup",
      description: "Park cleanup",
      location: "Central Park",
      event_date: Date.today,
      start_time: "16:00",
      end_time: "10:00",
      required_volunteers: 5,
      status: "open"
    )

    expect(event).not_to be_valid
    expect(event.errors[:start_time]).to include("must be before end time")
  end

  it "requires a positive number of volunteers" do
    event = Event.new(
      title: "Cleanup",
      description: "Park cleanup",
      location: "Central Park",
      event_date: Date.today,
      start_time: "10:00",
      end_time: "12:00",
      required_volunteers: 0,
      status: "open"
    )

    expect(event).not_to be_valid
    expect(event.errors[:required_volunteers]).to include("must be greater than 0")
  end
end
