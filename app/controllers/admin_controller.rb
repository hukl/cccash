class AdminController < ApplicationController
  def index
    @cashboxes = Cashbox.all
  end
end
