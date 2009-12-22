class WorkshiftsController < ApplicationController

  def index
  end

  def new
    @workshift = Workshift.new params[:workshift]
  end

  def create
    @workshift = Workshift.new params[:workshift]
    
    if @workshift.save
      redirect_to admin_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    @workshift = Workshift.find params[:id]
  end

  def update
    @workshift = Workshift.find params[:id]
    
    if @workshift.update_attributes( params[:workshift] )
      redirect_to admin_path
    else
      render :edit
    end
  end

  def destroy
    workshift = Workshift.find params[:id]
    
    workshift.destroy if workshift
    
    redirect_to admin_path
  end

end
