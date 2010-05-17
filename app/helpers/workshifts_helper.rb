module WorkshiftsHelper
  
  def cashboxes_for_select
    #available = Cashbox.all# - Cashbox.busy
    Cashbox.all.map {|cb| [cb.name, cb.id]}
  end
  
  def users_for_select
    #available = User.angels# - User.busy.angels
    User.angels.all.map {|a| [a.login, a.id]}
  end
  
end
