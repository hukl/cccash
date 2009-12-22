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
  
end
