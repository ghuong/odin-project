require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example_user)
    @another_user = users(:another_user)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select 'div.alert', "The form contains 4 errors."
  end

  test "successful edit with friendly forwarding" do
    # Attempt to access protected page while not logged-in
    get edit_user_path(@user)
    log_in_as(@user)
    # After login, friendly forwarding redirects to intended page
    assert_redirected_to edit_user_url(@user)
    follow_redirect!
    assert_template 'users/edit'
    # Friendly forwarding should now be disabled
    assert_nil session[:forwarding_url]
    # Edit user information
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, 
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    # Assert that user was updated
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
