require 'test_helper'

class CompanysControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get companys_new_url
    assert_response :success
  end

  test "should get show" do
    get companys_show_url
    assert_response :success
  end

  test "should get index" do
    get companys_index_url
    assert_response :success
  end

end
