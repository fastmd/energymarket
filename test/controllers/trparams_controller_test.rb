require 'test_helper'

class TrparamsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get trparams_new_url
    assert_response :success
  end

  test "should get show" do
    get trparams_show_url
    assert_response :success
  end

  test "should get index" do
    get trparams_index_url
    assert_response :success
  end

  test "should get edit" do
    get trparams_edit_url
    assert_response :success
  end

end
