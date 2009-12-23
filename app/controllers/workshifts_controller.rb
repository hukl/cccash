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
      respond_to do |format|
        format.html { redirect_to admin_path }
        format.js   { render_workshift_list }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js   { render :nothing => true}
      end
    end
  end

  def destroy
    workshift = Workshift.find params[:id]
    
    workshift.destroy if workshift
    
    redirect_to admin_path
  end
  
  
  def render_workshift_list
    render :update do |page|
      @workshifts = Workshift.all
      page['workshifts'].replace(render(:partial => 'workshifts/workshift_list'))
    end
  end

end
