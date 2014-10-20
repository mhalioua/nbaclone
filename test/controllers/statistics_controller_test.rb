require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  test "should get team" do
    get :team
    assert_response :success
  end

end
