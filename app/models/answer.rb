
class Answer < ApplicationRecord
  # Existing code before the patch
  # ...

  # Add any additional methods below this line
   
  def moderate!(action)
    case action
    when 'approve'
      update(status: 'approved')
    when 'reject'
      update(status: 'rejected')
    end
  end

end
