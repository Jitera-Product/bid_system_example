# SubmissionModerationService
class SubmissionModerationService
  def moderate(submission_id:, administrator_id:, action:, reason: nil)
    submission = Submission.find(submission_id)

    case action
    when 'approve'
      submission.update(status: 'approved')
    when 'reject'
      submission.update(status: 'rejected', reason: reason)
    when 'edit'
      # Apply the changes to the submission here
      submission.update(administrator_id: administrator_id)
    end

    # Log the moderation action
    ModerationLogWorker.perform_async(submission_id, administrator_id, action, reason, Time.current.to_i)

    # Return a confirmation message
    "Submission #{action}d successfully"
  end
end
