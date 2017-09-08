require 'test_helper'

class SrControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sr_index_url
    assert_response :success
  end

  test "should get show" do
    get sr_show_url
    assert_response :success
  end

end
