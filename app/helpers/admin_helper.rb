module AdminHelper
  def toggle_activation_link(workshift)
    if workshift.active?
      link_to_remote(
        'Deaktivieren',
        :url => workshift_path(workshift, :workshift => {:active => false}),
        :method => :put
      )
    else 
      link_to_remote(
        'Aktivieren',
        :url => workshift_path(workshift, :workshift => {:active => true}),
        :method => :put
      )
    end 
  end
end
