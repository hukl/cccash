class TicketsController < ApplicationController
  def index
    @tickets = Ticket.all
  end

  def new
    @ticket = Ticket.new params[:ticket]
  end

  def create
    @ticket = Ticket.new params[:ticket]
    
    if @ticket.save
      redirect_to tickets_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    @ticket = Ticket.find(params[:id])
  end

  def update
    @ticket = Ticket.find(params[:id])

    if @ticket.update_attributes(params[:ticket])
      redirect_to tickets_path
    else
      render :edit
    end
  end

  def destroy
    ticket = Ticket.find(params[:id])

    ticket.destroy if ticket

    redirect_to tickets_path
  end

  def sort
    params[:tickets].each_with_index do |id, index|
      Ticket.update_all( ["position = ?", index+1], ["id = ?", id] )
    end

    render :nothing => true
  end

end
