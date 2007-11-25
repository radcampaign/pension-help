require File.dirname(__FILE__) + '/../test_helper'
require 'restrictions_controller'

# Re-raise errors caught by the controller.
class RestrictionsController; def rescue_action(e) raise e end; end

class RestrictionsControllerTest < Test::Unit::TestCase
  fixtures :restrictions

  def setup
    @controller = RestrictionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:restrictions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_restrictions
    old_count = Restrictions.count
    post :create, :restrictions => { }
    assert_equal old_count+1, Restrictions.count
    
    assert_redirected_to restrictions_path(assigns(:restrictions))
  end

  def test_should_show_restrictions
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_restrictions
    put :update, :id => 1, :restrictions => { }
    assert_redirected_to restrictions_path(assigns(:restrictions))
  end
  
  def test_should_destroy_restrictions
    old_count = Restrictions.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Restrictions.count
    
    assert_redirected_to restrictions_path
  end
end
