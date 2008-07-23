require File.dirname(__FILE__) + '/../test_helper'
require 'email_this_page_controller'

# Re-raise errors caught by the controller.
class EmailThisPageController; def rescue_action(e) raise e end; end

class EmailThisPageControllerTest < Test::Unit::TestCase
  def setup
    @controller = EmailThisPageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
