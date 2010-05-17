# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def menu_for_user
    if current_user && current_user.admin?
      render :partial => "shared/admin_menu"
    elsif current_user && !current_user.admin?
      render :partial => "shared/user_menu"
    else
      render :partial => "shared/login_menu"
    end
  end
  
  def nice_price(price)
    if price.is_a?(Numeric)
      number_to_currency(price ,{:unit => "", :seperator => ","}) + '&euro;'
    end
  end
  
  def show_notice(secs = 3)
    visual_effect(:fade, 'notice', 
                  :queue => {:position => 'end', :scope => 'notice' }, 
                  :delay => secs, :duration => 4) +
    visual_effect(:appear, 'notice',
                  :queue => {:position => 'front', :scope => 'notice' }, 
                  :duration => 4)
  end
  
  def flash_js_tag
    if flash[:notice]
      javascript_tag(show_notice)
    end
  end
  
end
