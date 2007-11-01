require File.dirname(__FILE__) + '/../test_helper'
require 'agencies_controller'

# Re-raise errors caught by the controller.
class AgenciesController; def rescue_action(e) raise e end; end

class AgenciesControllerTest < Test::Unit::TestCase
  fixtures :agencies

  def setup
    @controller = AgenciesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:agencies)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_agency
    old_count = Agency.count
    post :create, :agency => { }
    assert_equal old_count+1, Agency.count
    
    assert_redirected_to agency_path(assigns(:agency))
  end

  def test_should_show_agency
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_agency
    put :update, :id => 1, :agency => { }
    assert_redirected_to agency_path(assigns(:agency))
  end
  
  def test_should_destroy_agency
    old_count = Agency.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Agency.count
    
    assert_redirected_to agencies_path
  end
end
