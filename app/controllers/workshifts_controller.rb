class WorkshiftsController < ApplicationController
  def index
    @workshifts = Workshift.find :all
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
    @workshift    = Workshift.find params[:id]
    @transactions = Transaction.paginate(
      :page       => params[:page],
      :per_page   => 15,
      :conditions => {:workshift_id => @workshift.id},
      :order      => "created_at desc"
    )
  end
  
  def billing
    @workshift = Workshift.find params[:id]
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
  
  def toggle_activation
    workshift   = Workshift.find params[:id]
    
    respond_to do |format|
      format.js do
        if workshift.toggle_activation
          @workshifts = Workshift.in_progress
          render :update do |page|
            page['workshifts'].replace(render(:partial => 'workshift_overview'))
          end
        else
          render :nothing => true
        end
      end
    end
  end
  
  def clear
    @workshift = Workshift.find params[:id]
    
    @workshift.transaction do
      @workshift.clear!
      @workshift.update_attributes! :cleared_by_id => current_user.id
      if params[:taint_user]
        @workshift.user.update_attributes! :tainted => true;
      end
    end
    
    redirect_to admin_path
  end

end
