module AdminHelper
  def toggle_activation_link(workshift)
    link_to_remote(
      (workshift.active? ? 'Deactivate' : 'Activate'),
      :url => toggle_activation_workshift_path( workshift ),
      :method => :put
    )
  end
end
