require "test_helper"

class Shared::NotificationComponentTest < ViewComponent::TestCase
  test "renders message text" do
    render_inline(Shared::NotificationComponent.new(message: "Card created"))

    assert_text "Card created"
  end

  test "has flash controller data attribute" do
    render_inline(Shared::NotificationComponent.new(message: "Card created"))

    assert_selector "[data-controller='flash']"
  end

  test "has dismiss button" do
    render_inline(Shared::NotificationComponent.new(message: "Card created"))

    assert_selector "button[data-action='click->flash#dismiss']"
  end
end
