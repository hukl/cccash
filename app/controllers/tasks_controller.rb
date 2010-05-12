class TasksController < ApplicationController
  def index
  end

  def print_receipt
    transaction = Transaction.find_by_id( params[:transaction_id] )
    cashbox     = current_user.workshift.cashbox
    
    if transaction && cashbox
      cashbox.printer.print transaction.to_bon params[:billing_address]
    end
    
    redirect_to :controller => :tasks, :action => :index
  end

end
