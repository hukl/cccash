module CartHelper
  def wait_for_close_with_button(action=nil)
    javascript_tag(
      remote_function( :url => wait_for_cashbox_cart_path )
    )
  end
end
