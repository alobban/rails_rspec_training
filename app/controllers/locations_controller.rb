class LocationsController < ApplicationController
  def create
  	@location = Location.new(location_params)
  	if @location.save
  	  redirect_to location_path(@location.id)
  	else
  	  render action: "new"
  	end
  end

  def show
  	begin
  	  @location = Location.find(params[:id])
  	rescue ActiveRecord::RecordNotFound
  	  render status: 404
  	end
  end

  def index
  	@locations = Location.all
  end

  def destroy
  	begin
  	  Location.destroy(params[:id])
  	rescue
  	  render status: 404
  	end
  end

  private

  def location_params
  	params.require(:location).permit(:latitude, :longitude)
  end
end
