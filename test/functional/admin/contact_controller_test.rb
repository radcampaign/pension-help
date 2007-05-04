require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/contact_controller'

# Re-raise errors caught by the controller.
class Admin::ContactController; def rescue_action(e) raise e end; end

class Admin::ContactControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::ContactController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
