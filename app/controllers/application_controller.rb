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
end
