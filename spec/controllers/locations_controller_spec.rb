require 'rails_helper'

RSpec.describe LocationsController, :type => :controller do
  describe "#create" do
  	subject { post :create, { location: 
  	  { latitude: 25.0, 
  	  	longitude: -40.0 }
  	  }
  	}
  	it "saves the location" do
  	  subject
  	  Location.all.count.should == 1
  	end
  	it "should redirect to show the created location" do
  	  subject.should redirect_to(location_path(Location.first.id))
  	end
  end

  describe "#new" do
  	context "when invalid longitude" do
  	  subject { post :create, { location: 
  	  	{ latitude: 25.0 } } }
  	  its(:status) { should == 200 } # OK
  	  it "should render the new view" do
  	  	subject
  	  	response.should render_template("new")
  	  end
  	end
  end

  describe "#show" do
  	context "when the location exists" do
  	  let(:location) { Location.create(latitude: 25.0, longitude: -40.0) }
  	  subject { get :show, id: location.id }
  	  it "assigns @location" do
  	  	subject
  	  	assigns(:location).should eq(location)
  	  end
  	  it "renders the show template" do
  	  	subject
  	  	response.should render_template("show")
  	  end
  	end

  	context "when thel ocation does not exist" do
  	  subject { get :show, id: 404 }
  	  its(:status) { should == 404 }
  	end
  end

  describe "#index" do
  	context "when there are some locations" do
  	  let(:locations) do
  	  	[
  	  	  Location.create(latitude: 25.0,
  	  	  	longitude: -40.0),
  	  	  Location.create(latitude: -10.0,
  	  	  	longitude: 42.0)
  	  	]
  	  end
  	  #TODO check with let!
  	  before { locations }
  	  subject { get :index }
  	  it "assigns @locations" do
  	  	subject # let!
  	  	assigns(:locations).should eq(locations)
  	  end
  	end

  	context "when there are no locations" do
  	  subject { get :index }
  	  it "assigns @locations" do
  	  	subject
  	  	assigns(:locations).should eq([])
  	  end
  	end
  end

  describe "#destroy" do
  	context "when the location exists" do
  	  let (:location) { Location.create(
  	  	latitude: 25.0, longitude: -40)
  	  }
  	  subject { post :destroy, id: location.id }
  	  it "deletes the location" do
  	  	subject
  	  	Location.all.count.should == 0
  	  end
  	end
  end

  describe "#near" do
  	let(:location) { double("Location") }
  	before do
  	  Location.should_receive(:find).with(42).and_return(location)
  	end
  	context "when the supplied coordinates are near" do
  	  it "renders the near view" do
  	  	location.should_receive(:near?).with(25.0, 62.1, 1.0).and_return(true)
  	  	post :near, id: "42", latitude: 25.0, longitude: 62.1
  	  	response.should render_template("near")
  	  end
  	end

  	context "when the supplied coordinates are far" do
  	  it "renders the far view" do
  	  	location.should_receive(:near?).with(25.0, 62.1, 1.0).and_return(false)
  	  	post :near, id: "42", latitude: 25.0, longitude: 62.1
  	  	response.should render_template("far")
  	  end
  	end
  end
end
