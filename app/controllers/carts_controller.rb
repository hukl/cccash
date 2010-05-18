class CartsController < ApplicationController

  skip_before_filter :admin_status_required
  
  before_filter      :get_cart, :get_cashbox
  before_filter      :check_workshift_and_ip
  before_filter      :check_valid_session, :only => :checkout
  
  def show
    @cart.reset
    session[:valid] = true
  end
  
  def add_ticket_to
    ticket = Ticket.find(params[:id])
    
    if params[:special_guest_id]
      @cart.special_guest_id = params[:special_guest_id]
    end
        
    render :update do |page|
      unless @cart.add( ticket )
        flash[:notice] = "Cannot add another custom ticket"
        page[:notice].replace :partial => 'shared/notice'
      end
      
      flash[:notice] = nil
      page[:cart].replace render(:partial => 'cart')
    end
  end
  
  def remove_ticket_from
    @cart.remove params[:position].to_i
    
    render :update do |page|
      page[:cart].replace render(:partial => 'cart')
    end
  end
  
  # The cart object tries to create a valid transaction from the given tickets
  # and workshift. If the resulting transaction is valid the regular checkout
  # template is rendered. If not it redirects back to the cart to start over.
  def checkout
    session[:valid] = false
    @transaction = @cart.create_transaction(:workshift => current_user.workshift)
    
    if @transaction.errors.empty?
      begin
        @cashbox.open_drawer
      rescue => e
        @transaction.cancel
        flash[:notice] = "( #{e.class} ) - #{e.message}\n" \
                        "Last Transaction will be canceled"
        redirect_to cart_path
        return
      end
      @cashbox.printer.print(@transaction.to_bon)
      render
      @cart.reset
    else
      flash[:notice] = "Invalid Transaction: #{transaction_errors}"
      redirect_to cart_path
    end
  end
  
  def cancel_most_recent
    @last_transaction = current_user.workshift.transactions.last
    
    unless @last_transaction && !@last_transaction.canceled? 
      flash[:notice] = "Could not cancel transcation"
      redirect_to cart_path
    end
  end
  
  def confirm_cancel
    if User.authenticate(params[:login], params[:password]).try(:admin?)
      @last_transaction = Transaction.find(params[:transaction_id])
      @last_transaction.cancel if @last_transaction
      @cashbox.open_drawer
    else
      flash[:notice] = "Invalid Admin Account"
      redirect_to cart_path
    end
  end
  
  def wait_for_cashbox
    respond_to do |format|
      format.js do
        if @cashbox.wait_for_closed_drawer
          render :update do |page|
            page.redirect_to cart_path
          end
        else
          render :nothing => true
        end
      end
    end
  end
  
  
  private
    
    def get_cart
      @cart = ( session[:cart] ||= Cart.new )
    end
    
    def get_cashbox
      if current_user && current_user.workshift
        @cashbox = current_user.workshift.cashbox
      end
    end
    
    
    def check_valid_session
      if session[:valid] == false
        flash[:notice] = "Exessive Checkout Error - Calm down or fix your mouse"
        redirect_to cart_path
      end
    end
    
    def transaction_errors
      errors = []
      @transaction.errors.each_error do |field, error|
        errors << error.message
      end
      errors.join(",")
    end
  
end
