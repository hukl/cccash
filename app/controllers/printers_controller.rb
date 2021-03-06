class PrintersController < ApplicationController
  def index
  end

  def new
    @printer = Printer.new params[:printer]
  end

  def create
    @printer = Printer.new params[:printer]
    
    if @printer.save
      redirect_to admin_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    @printer = Printer.find(params[:id])
  end

  def update
    @printer = Printer.find(params[:id])
    
    if @printer.update_attributes(params[:printer])
      redirect_to admin_path
    else
      render :edit
    end
  end

  def destroy
    printer = Printer.find(params[:id])
    
    printer.destroy if printer
    
    redirect_to admin_path
  end

end
