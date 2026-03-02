require "test_helper"

class PresenceChannelTest < ActionCable::Channel::TestCase
  test "subscribes successfully with board_id" do
    subscribe(board_id: boards(:demo).id)
    assert subscription.confirmed?
    assert_has_stream "presence_board_#{boards(:demo).id}"
  end
end
