class CashboxesController < ApplicationController
  def index
  end

  def new
    @cashbox = Cashbox.new params[:cashbox]
  end

  def create
    @cashbox = Cashbox.new params[:cashbox]
    
    if @cashbox.save
      redirect_to admin_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    @cashbox = Cashbox.find(params[:id])
  end

  def update
    @cashbox = Cashbox.find(params[:id])
    
    if @cashbox.update_attributes(params[:cashbox])
      redirect_to admin_path
    else
      render :edit
    end
  end

  def destroy
    cashbox = Cashbox.find(params[:id])
    
    cashbox.destroy if cashbox
    
    redirect_to admin_path
  end

end
