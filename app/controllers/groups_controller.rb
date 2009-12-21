class GroupsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @group = Group.new params[:group]

    if @group.save
      redirect_to admin_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to admin_path
    else
      render :edit
    end
  end

  def destroy
    group = Group.find(params[:id])

    group.destroy if group

    redirect_to admin_path
  end

end
