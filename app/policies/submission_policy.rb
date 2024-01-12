class SubmissionPolicy
  def moderate?(administrator)
    administrator.has_role?(:moderator)
  end
end


