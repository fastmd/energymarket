require 'test_helper'

class MetersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get meters_index_url
    assert_response :success
  end

  test "should get new" do
    get meters_new_url
    assert_response :success
  end

  test "should get create" do
    get meters_create_url
    assert_response :success
  end

  test "should get update" do
    get meters_update_url
    assert_response :success
  end

  test "should get show" do
    get meters_show_url
    assert_response :success
  end

end
