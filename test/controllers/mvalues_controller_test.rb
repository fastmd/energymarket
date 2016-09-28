require 'test_helper'

class MvaluesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get mvalues_new_url
    assert_response :success
  end

  test "should get edit" do
    get mvalues_edit_url
    assert_response :success
  end

  test "should get show" do
    get mvalues_show_url
    assert_response :success
  end

  test "should get index" do
    get mvalues_index_url
    assert_response :success
  end

end
