require "rails_helper"

RSpec.describe "Events", type: :request do
  it "redirects to volunteer login when not authenticated" do
    get events_path

    expect(response).to redirect_to(volunteer_login_path)
  end
end
