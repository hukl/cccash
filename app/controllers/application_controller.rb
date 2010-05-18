# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
	before_filter :login_required, :admin_status_required
  
  helper :all # include all helpers, all the time
  protect_from_forgery
  # See ActionController::RequestForgeryProtection for details
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def admin_status_required
    if current_user && !current_user.admin?
      render :nothing => true, :status => 401
    end
  end
  
  def workshift_active?
    current_user && current_user.active_workshift
  end

  def cashbox_valid?
    if current_user && current_user.active_workshift
      request.remote_ip == current_user.active_workshift.cashbox.ip
    end
  end

  def check_workshift_and_ip
    return unless current_user
  
    unless workshift_active? && cashbox_valid?
      if !workshift_active?
        flash[:notice] = "Your workshift has ended"
      elsif !cashbox_valid?
        flash[:notice] = "This is not your cashbox"
      end
  
      current_user.end_workshift
  
      logout_keeping_session!
      respond_to do |format|
        format.html { redirect_to new_session_path }
        format.js do
          render :update do |page|
            page.redirect_to("/")
          end
        end
      end
    end
  end

end
