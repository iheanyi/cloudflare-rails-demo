class PresenceChannel < ApplicationCable::Channel
  def subscribed
    @board_id = params[:board_id]
    stream_from "presence_board_#{@board_id}"

    increment_viewers
    broadcast_count
  end

  def unsubscribed
    decrement_viewers
    broadcast_count
  end

  private

  def cache_key
    "presence:board:#{@board_id}"
  end

  def increment_viewers
    count = Rails.cache.read(cache_key).to_i
    Rails.cache.write(cache_key, count + 1, expires_in: 1.hour)
  end

  def decrement_viewers
    count = Rails.cache.read(cache_key).to_i
    Rails.cache.write(cache_key, [count - 1, 0].max, expires_in: 1.hour)
  end

  def broadcast_count
    count = Rails.cache.read(cache_key).to_i
    ActionCable.server.broadcast("presence_board_#{@board_id}", { count: count })
  end
end
