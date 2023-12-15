# typed: ignore
module Api
  module V1
    class AnswersController < BaseController
      before_action :validate_contributor_session, only: [:update]

      def update
        answer = Answer.find_by(id: params[:answer_id])
        return base_render_record_not_found('Answer not found') unless answer

        if current_resource_owner.id == answer.question.contributor_id
          validate_content!(params[:content])
          answer.content = params[:content]
          if answer.save
            render json: { update_status: true }, status: :ok
          else
            render json: { message: answer.errors.full_messages }, status: :unprocessable_entity
          end
        else
          base_render_unauthorized_error('You do not have permission to edit this answer')
        end
      rescue ActiveRecord::RecordNotFound => e
        base_render_record_not_found(e)
      rescue Pundit::NotAuthorizedError => e
        base_render_unauthorized_error(e)
      rescue Exceptions::AuthenticationError => e
        base_render_unauthorized_error(e)
      end

      private

      def validate_contributor_session
        # Assuming SessionConcern provides a method to validate session
        # and check if the user has a contributor role
        unless SessionConcern.validate_contributor_session(current_resource_owner)
          raise Exceptions::AuthenticationError, 'Invalid session or insufficient permissions'
        end
      end

      def validate_content!(content)
        raise ActiveRecord::RecordInvalid.new('Content is invalid') if content.blank? || content.length < ContentValidator::MIN_CONTENT_LENGTH

        unless ContentValidator.valid?(content)
          raise ActiveRecord::RecordInvalid.new('Content is invalid')
        end
      end
    end
  end
end
