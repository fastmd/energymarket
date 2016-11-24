require 'test_helper'

class FurnizorsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get furnizors_new_url
    assert_response :success
  end

  test "should get index" do
    get furnizors_index_url
    assert_response :success
  end

  test "should get edit" do
    get furnizors_edit_url
    assert_response :success
  end

end
