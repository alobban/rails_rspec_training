require 'rails_helper'

# RSpec.describe Location, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

describe Location do
  let(:latitude) { 38.911268 }
  let(:longitude) { -77.444243 }
  let(:air_space) { Location.new(latitude: 38.911268, longitude: -77.444243) }
  describe "#initialize" do
  	subject { air_space }
  	its (:latitude) { should == latitude }
  	its (:longitude) { should == longitude }
  end

  describe "#near?" do
  	context "when within the specified radius" do
  	  subject { air_space }
  	  it { should be_near(latitude, longitude, 1) }  	  
  	end

  	context "when outside the specified radius" do
  	  subject { air_space }
  	  it { should_not be_near(latitude * 10, longitude * 10, 1) }
  	end

    context "when a negative radius is used" do
      it "raises an error" do
        expect { air_space.near?(latitude, longitude, -1) }.to raise_error ArgumentError
      end
    end
  end
end

describe "validations" do
  before { subject.valid? }
  [ :latitude, :longitude ].each do |coordinate|
  	context "when #{coordinate} is nil" do
  	  subject { Location.new(coordinate => nil) }
  	  it "shouldn't allow blank #{coordinate}" do
  	  	expect(subject.errors_on(coordinate)).to include("can't be blank")
  	  end
  	end

  	context "when #{coordinate} isn't numeric" do
  	  subject { Location.new(coordinate => 'forty-two') }
  	  it "shouldn't all non-numeric #{coordinate}" do
  	  	expect(subject.errors_on(coordinate)).to include("is not a number")
  	  end
  	end

  	context "when #{coordinate} is an acceptable value" do
  	  subject { Location.new(coordinate => 42) }
  	  it "should have no errors for #{coordinate}" do
  	  	expect(subject).to have(0).errors_on(coordinate)
  	  end
  	end
  end
end

