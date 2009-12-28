class TasksController < ApplicationController
  
  before_filter :login_required
  
  def index
  end

  def print_receipt
    transaction = Transaction.find_by_id( params[:transaction_id] )
    cashbox     = current_user.workshift.cashbox
    
    if transaction && cashbox
      cashbox.printer.print transaction.to_bon
    end
    
    redirect_to :controller => :tasks, :action => :index
  end

end
