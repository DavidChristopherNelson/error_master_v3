require 'test_helper'

class WorkersControllerTest < ActionDispatch::IntegrationTest
  test 'should get status' do
    get workers_status_url
    assert_response :success
  end
end
