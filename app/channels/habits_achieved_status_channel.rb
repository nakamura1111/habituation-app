class HabitsAchievedStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "habits_achieved_status_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
