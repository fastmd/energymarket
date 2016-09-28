require 'test_helper'

class MpointsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get mpoints_new_url
    assert_response :success
  end

  test "should get show" do
    get mpoints_show_url
    assert_response :success
  end

  test "should get index" do
    get mpoints_index_url
    assert_response :success
  end

  test "should get edit" do
    get mpoints_edit_url
    assert_response :success
  end

end
