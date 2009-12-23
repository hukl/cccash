class CartsController < ApplicationController
  
  before_filter :get_cart, :get_cashbox
  
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
      redirect_to cart_path
    else
      flash[:notice] = "Invalid Transaction: #{transaction_errors}"
      redirect_to cart_path
    end
  end
  
  
  private
    
    def get_cart
      @cart = ( session[:cart] ||= Cart.new )
    end
    
    def get_cashbox
      @cashbox = current_user.workshift.cashbox
    end
    
    def transaction_errors
      errors = []
      @transaction.errors.each_error do |field, error|
        errors << error.message
      end
      errors.join(",")
    end
  
end
