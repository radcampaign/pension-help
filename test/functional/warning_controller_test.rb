require File.dirname(__FILE__) + '/../test_helper'
require 'warning_controller'

# Re-raise errors caught by the controller.
class WarningController; def rescue_action(e) raise e end; end

class WarningControllerTest < Test::Unit::TestCase
  def setup
    @controller = WarningController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
