module WorkshiftsHelper
  
  def cashboxes_for_select
    available = Cashbox.all - Workshift.active.map {|ws| ws.cashbox}
    available.map {|cb| [cb.name, cb.id]}
  end
  
  def users_for_select
    available = User.angels - User.busy.angels
    available.map do |a|
      if a.tainted?
        ["#{a.login} (tainted!)", a.id]
      else
        [a.login, a.id]
      end
    end 
  end
  
end
