class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]
  before_action :set_chat_channel, only: [:create]
  before_action :validate_message_limit, only: [:create]

  def create
    authorize :message, policy_class: Api::MessagesPolicy

    message_content = params[:content].to_s
    if message_content.length > 256
      # Truncate the message to meet the requirement
      message_content = message_content[0...256]
    end

    # Ensure sender_id corresponds to the logged-in user
    sender_id = current_resource_owner.id
    return render_error('Sender is not the logged-in user', :forbidden) unless sender_id.to_s == params[:sender_id].to_s

    message = @chat_channel.messages.create(
      user_id: sender_id,
      content: message_content,
      created_at: Time.current
    )

    if message.persisted?
      render json: { message_id: message.id, created_at: message.created_at, content: message.content }, status: :created
    else
      render_error(message.errors.full_messages.to_sentence, :unprocessable_entity)
    end
  rescue Pundit::NotAuthorizedError => e
    render_error(e.message, :forbidden)
  rescue ActiveRecord::RecordNotFound => e
    render_error(e.message, :not_found)
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by!(id: params[:chat_channel_id])
    render_error('Chat channel is not active', :unprocessable_entity) unless @chat_channel.active?
  end

  def validate_message_limit
    if @chat_channel.messages.count >= 500
      render_error('Message limit exceeded for this chat channel', :unprocessable_entity)
    end
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
