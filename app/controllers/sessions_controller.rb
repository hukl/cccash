# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required,        :except => :destroy
  skip_before_filter :admin_status_required

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
    dispatch_to_landing_page if current_user
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    
    if user && (user.admin? || user.active_workshift)
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag

      flash[:notice] = "Logged in successfully"
      dispatch_to_landing_page
    else
      if user && user.angel?
        flash[:notice] = "No workshift or workshift deactivated"
      else
        flash[:notice] = "Could not log in"
      end
      
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def dispatch_to_landing_page
    if self.current_user.admin?
      redirect_to admin_path
    else
      self.current_user.active_workshift.login!
      redirect_to cart_path
    end
  end
 
  def destroy
    self.current_user.active_workshift.logout! if self.current_user.angel?
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

end
