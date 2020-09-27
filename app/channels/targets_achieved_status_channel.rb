class TargetsAchievedStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "targets_achieved_status_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
