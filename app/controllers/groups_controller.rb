class GroupsController < ApplicationController
  
  before_filter :login_required
  
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new params[:group]
  end

  def create
    @group = Group.new params[:group]

    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def show
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to groups_path
    else
      render :edit
    end
  end

  def destroy
    group = Group.find(params[:id])

    group.destroy if group

    redirect_to groups_path
  end

end
