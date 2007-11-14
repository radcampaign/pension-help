require File.dirname(__FILE__) + '/../test_helper'
require 'plans_controller'

# Re-raise errors caught by the controller.
class PlansController; def rescue_action(e) raise e end; end

class PlansControllerTest < Test::Unit::TestCase
  fixtures :plans

  def setup
    @controller = PlansController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:plans)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_plan
    old_count = Plan.count
    post :create, :plan => { }
    assert_equal old_count+1, Plan.count
    
    assert_redirected_to plan_path(assigns(:plan))
  end

  def test_should_show_plan
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_plan
    put :update, :id => 1, :plan => { }
    assert_redirected_to plan_path(assigns(:plan))
  end
  
  def test_should_destroy_plan
    old_count = Plan.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Plan.count
    
    assert_redirected_to plans_path
  end
end
