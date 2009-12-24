class SpecialGuestsController < ApplicationController
  
  def index
    @special_guests = SpecialGuest.all
  end

  def new
  end

  def create
    @special_guest = SpecialGuest.new params[:special_guest]
    @special_guest.assign_ticket params[:ticket]
    
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
