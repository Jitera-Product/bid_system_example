class Answer < ApplicationRecord
  belongs_to :question

  def moderate!(action)
    case action
    when 'approve'
      update(status: 'approved')
    when 'reject'
      update(status: 'rejected')
    end
  end

  # Add any additional methods below this line

end
