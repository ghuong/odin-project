require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:example_user)
  end

  test "password resets" do
    # Request a password reset
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Requesting for an invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Requesting for a valid email
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    
    # Accessing the password reset form
    user = assigns(:user)
    # Using a wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Using an inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Using the right email, but wrong token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url
    # Using the right email and right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # Updating password
    # With Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:               "foobaz",
                            password_confirmation: "barquuz" } }
    assert_select 'div#error_explanation'
    # With empty password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # With valid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user

    # Assert that reset_digest is erased afterwards
    assert_nil user.reload.reset_digest
  end

  test "expired token" do
    # Request a password reset
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    
    # Pretend reset was sent 3 hours ago
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)

    # Try to update password
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }

    # Assert that the page redirected, and contains the word "expired"
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end
end
