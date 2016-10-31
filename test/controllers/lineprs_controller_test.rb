require 'test_helper'

class LineprsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get lineprs_new_url
    assert_response :success
  end

  test "should get show" do
    get lineprs_show_url
    assert_response :success
  end

  test "should get index" do
    get lineprs_index_url
    assert_response :success
  end

  test "should get edit" do
    get lineprs_edit_url
    assert_response :success
  end

end
