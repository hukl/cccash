require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  test "get index" do
    get :index
    assert_response :success
  end

  test "get new" do
    get :new
    assert_response :success
  end

  test "create new group" do
    assert_difference "Group.count", +1 do
      post :create, :group => {
        :name       => "friends", 
      }
    end

    group = Group.last

    assert_equal "friends", group.name
    assert_redirected_to admin_path
  end

  test "get edit" do
    get :edit, :id => 1
    assert_response :success
  end

  test "update a group" do
    put :update, :id => 1, :group => {
      :name   => "members"
    }

    assert_redirected_to admin_path

    assert_equal "members", Group.find(1).name
  end

  test "deleting a group" do
    assert_difference "Group.count", -1 do
      delete :destroy, :id => 1
    end

    assert_redirected_to admin_path
  end

end
