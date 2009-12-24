module SpecialGuestsHelper
  
  def groups_for_select
    Group.all.map {|group| [group.name, group.id]}
  end
  
  def tickets_for_select
    Ticket.standard.map {|ticket| [ticket.name, ticket.id]}
  end
  
end
