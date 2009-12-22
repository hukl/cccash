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
  
  
  
  private
    
    def get_cart
      @cart = ( session[:cart] ||= Cart.new )
    end
  
end
