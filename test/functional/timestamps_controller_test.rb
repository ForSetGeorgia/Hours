require 'test_helper'

class TimestampsControllerTest < ActionController::TestCase
  setup do
    @timestamp = timestamps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timestamps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timestamp" do
    assert_difference('Timestamp.count') do
      post :create, timestamp: { diff_level: @timestamp.diff_level, duration: @timestamp.duration, notes: @timestamp.notes, project_id: @timestamp.project_id, user_id: @timestamp.user_id }
    end

    assert_redirected_to timestamp_path(assigns(:timestamp))
  end

  test "should show timestamp" do
    get :show, id: @timestamp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timestamp
    assert_response :success
  end

  test "should update timestamp" do
    put :update, id: @timestamp, timestamp: { diff_level: @timestamp.diff_level, duration: @timestamp.duration, notes: @timestamp.notes, project_id: @timestamp.project_id, user_id: @timestamp.user_id }
    assert_redirected_to timestamp_path(assigns(:timestamp))
  end

  test "should destroy timestamp" do
    assert_difference('Timestamp.count', -1) do
      delete :destroy, id: @timestamp
    end

    assert_redirected_to timestamps_path
  end
end
