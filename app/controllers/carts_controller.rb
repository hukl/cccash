class CartsController < ApplicationController
  
  before_filter :get_cart
  
  def show
    
  end
  
  def add_ticket_to
    ticket = Ticket.find(params[:id])
    @cart.add ticket
    
    render :update do |page|
      page[:cart].replace render(:partial => 'cart')
    end
  end
  
  def remove_ticket_from
    @cart.remove params[:position].to_i
    
    render :update do |page|
      page[:cart].replace render(:partial => 'cart')
    end
  end
  
  def checkout
    @transaction = @cart.create_transaction(:workshift => current_user.workshift)
    
    if @transaction.errors.empty?
      flash[:notice] = "Super"
      render :show
    else
      flash[:error] = "Invalid Transaction"
      render :show
    end
  end
  
  
  private
    
    def get_cart
      @cart = ( session[:cart] ||= Cart.new )
    end
  
end
