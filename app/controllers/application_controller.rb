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

  def check_workshift_and_ip
    unless current_user &&
           current_user.active_workshift &&
           ip_allowed = request.remote_ip == current_user.active_workshift.cashbox.ip
      flash[:notice] = if not ip_allowed
        "This is not your cashbox"
      else
        "Your workshift has ended"
      end

      if current_user.workshift &&
         current_user.workshift.aasm_events_for_current_state.include?(:logout)
        current_user.workshift.logout!
      end
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
