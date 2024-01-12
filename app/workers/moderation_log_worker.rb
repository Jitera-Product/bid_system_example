class ModerationLogWorker
  include Sidekiq::Worker

  def perform(submission_id:, administrator_id:, action:, reason: nil, timestamp: nil)
    timestamp ||= Time.current.to_i
    # Assuming there is a ModerationLog model with the following fields:
    # submission_id, administrator_id, action, reason, created_at
    ModerationLog.create!(
      submission_id: submission_id,
      administrator_id: administrator_id,
      action: action,
      reason: reason,
      created_at: Time.at(timestamp)
    )
  end
end
