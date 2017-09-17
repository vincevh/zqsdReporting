require 'test_helper'

class SrsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sr = srs(:one)
  end

  test "should get index" do
    get srs_url
    assert_response :success
  end

  test "should get new" do
    get new_sr_url
    assert_response :success
  end

  test "should create sr" do
    assert_difference('Sr.count') do
      post srs_url, params: { sr: { comment: @sr.comment, datetime: @sr.datetime, hero: @sr.hero, newsr: @sr.newsr, performance: @sr.performance, srvariation: @sr.srvariation, userid: @sr.userid, winloss: @sr.winloss } }
    end

    assert_redirected_to sr_url(Sr.last)
  end

  test "should show sr" do
    get sr_url(@sr)
    assert_response :success
  end

  test "should get edit" do
    get edit_sr_url(@sr)
    assert_response :success
  end

  test "should update sr" do
    patch sr_url(@sr), params: { sr: { comment: @sr.comment, datetime: @sr.datetime, hero: @sr.hero, newsr: @sr.newsr, performance: @sr.performance, srvariation: @sr.srvariation, userid: @sr.userid, winloss: @sr.winloss } }
    assert_redirected_to sr_url(@sr)
  end

  test "should destroy sr" do
    assert_difference('Sr.count', -1) do
      delete sr_url(@sr)
    end

    assert_redirected_to srs_url
  end
end
