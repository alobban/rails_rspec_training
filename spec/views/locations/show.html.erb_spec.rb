require "rails_helper"

describe "locations/show" do
  before do
    assign(:location, 
      stub_model(Location, latitude: 42.0, 
        longitude: -12.4)
      )
  end
  it "displays the latitude" do
  	render
  	expect(rendered).to match /Latitude:\S*42\.0/
  end
  it "displays the longitude" do
  	render
  	expect(rendered).to match /Longitude:\S*12\.4/
  end
end