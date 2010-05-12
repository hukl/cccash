class TransactionsController < ApplicationController
  
  before_filter :login_required
  
  def index
    @transactions = Transaction.paginate(
      :page     => params[:page],
      :order    => "created_at desc",
      :per_page => 15
    ) 
  end

  def show
  end

  def workshift
  end

end
