require 'test_helper'

class FilialsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get filials_index_url
    assert_response :success
  end

  test "should get show" do
    get filials_show_url
    assert_response :success
  end

  test "should get edit" do
    get filials_edit_url
    assert_response :success
  end

  test "should get new" do
    get filials_new_url
    assert_response :success
  end

end
