require 'test_helper'

class PinAttributesControllerTest < ActionController::TestCase
  setup do
    @pin_attribute = pin_attributes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pin_attributes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pin_attribute" do
    assert_difference('PinAttribute.count') do
      post :create, pin_attribute: { name: @pin_attribute.name }
    end

    assert_redirected_to pin_attribute_path(assigns(:pin_attribute))
  end

  test "should show pin_attribute" do
    get :show, id: @pin_attribute
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pin_attribute
    assert_response :success
  end

  test "should update pin_attribute" do
    patch :update, id: @pin_attribute, pin_attribute: { name: @pin_attribute.name }
    assert_redirected_to pin_attribute_path(assigns(:pin_attribute))
  end

  test "should destroy pin_attribute" do
    assert_difference('PinAttribute.count', -1) do
      delete :destroy, id: @pin_attribute
    end

    assert_redirected_to pin_attributes_path
  end
end
