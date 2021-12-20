require "test_helper"

class DecoErrorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deco_error = deco_errors(:one)
  end

  test "should get index" do
    get deco_errors_url
    assert_response :success
  end

  test "should get new" do
    get new_deco_error_url
    assert_response :success
  end

  test "should create deco_error" do
    assert_difference('DecoError.count') do
      post deco_errors_url, params: { deco_error: {  } }
    end

    assert_redirected_to deco_error_url(DecoError.last)
  end

  test "should show deco_error" do
    get deco_error_url(@deco_error)
    assert_response :success
  end

  test "should get edit" do
    get edit_deco_error_url(@deco_error)
    assert_response :success
  end

  test "should update deco_error" do
    patch deco_error_url(@deco_error), params: { deco_error: {  } }
    assert_redirected_to deco_error_url(@deco_error)
  end

  test "should destroy deco_error" do
    assert_difference('DecoError.count', -1) do
      delete deco_error_url(@deco_error)
    end

    assert_redirected_to deco_errors_url
  end
end
