require 'test_helper'

class IndexControllerTest < ActionController::TestCase
  test "should get date" do
    get :date
    assert_response :success
  end

  test "should get team" do
    get :team
    assert_response :success
  end

end
