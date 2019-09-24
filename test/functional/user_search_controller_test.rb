require "test_helper"

class UserSearchControllerTest < ActionController::TestCase
  setup do
    login_as_stub_user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should show commented editions" do
    @guide = FactoryBot.create(:guide_edition)
    FactoryBot.create(:guide_edition)

    @user.record_note @guide, "I like this edition very much"
    get :index

    assert_response :success
    assert_equal [@guide.id], assigns[:editions].map(&:id)
  end

  test "should show assigned editions" do
    @guide = FactoryBot.create(:guide_edition) do |edition|
      @user.assign(edition, @user)
    end

    get :index

    assert_response :success
    assert_equal [@guide.id], assigns[:editions].map(&:id)
  end

  test "should handle simple title filter values" do
    # no assertions, just validating that the Regexp is fine like this
    get(:index, params: { string_filter: "stuff" })
  end

  test "should safely handle title filter values" do
    # no assertions; just validating that the Regexp is successfully created when the input contains Regexp special chars
    get(:index, params: { string_filter: "(stuff" })
  end
end
