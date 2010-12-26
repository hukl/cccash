class SpecialGuestsController < ApplicationController

  skip_before_filter :admin_status_required
  
  def index
    @special_guests = SpecialGuest.paginate :page => params[:page]
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
          @special_guest = SpecialGuest.find(params[:id])
          if !@special_guest.checked_in then
            @cart = ( session[:cart] ||= Cart.new )
            @cart.reset
            session[:valid] = true
          else
            flash[:notice] = "This guest already checked in!"
            redirect_to cart_path
          end
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  def search
    unless params[:search_term].blank?
      @results = SpecialGuest.search params[:search_term], :star => true, :limit => 10
    else
      @results = []
    end
    
    render :update do |page|
      page[:search_results].replace :partial => 'search_results'
    end
  end

end
