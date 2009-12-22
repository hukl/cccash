module WorkshiftsHelper
  
  def cashboxes_for_select
    available = Cashbox.all - Cashbox.busy
    available.map {|cb| [cb.name, cb.id]}
  end
  
  def users_for_select
    available = User.angels - User.busy.angels
    available.map {|a| [a.login, a.id]}
  end
  
end
