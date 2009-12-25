class SpecialGuestsController < ApplicationController
  
  def index
    @special_guests = SpecialGuest.all
  end

  def new
    @special_guest  = SpecialGuest.new params[:special_guest]
  end

  def create
    @special_guest = SpecialGuest.new params[:special_guest]
    @special_guest.assign_ticket params[:ticket]
    
    if @special_guest.save
      redirect_to special_guests_path
    else
      render :new
    end
    
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  def search
    unless params[:search_term].blank?
      @results = SpecialGuest.search params[:search_term], :star => true
    else
      @results = []
    end
    
    render :update do |page|
      page[:search_results].replace :partial => 'search_results'
    end
  end

end


