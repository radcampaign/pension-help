require File.dirname(__FILE__) + '/../test_helper'
require 'partners_controller'

# Re-raise errors caught by the controller.
class PartnersController; def rescue_action(e) raise e end; end

class PartnersControllerTest < Test::Unit::TestCase
  fixtures :partners

  def setup
    @controller = PartnersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:partners)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_partner
    old_count = Partner.count
    post :create, :partner => { }
    assert_equal old_count+1, Partner.count
    
    assert_redirected_to partner_path(assigns(:partner))
  end

  def test_should_show_partner
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_partner
    put :update, :id => 1, :partner => { }
    assert_redirected_to partner_path(assigns(:partner))
  end
  
  def test_should_destroy_partner
    old_count = Partner.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Partner.count
    
    assert_redirected_to partners_path
  end
end
