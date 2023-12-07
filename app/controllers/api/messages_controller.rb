class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show]
  before_action :set_chat_channel, only: %i[create index show]
  before_action :validate_message_limit, only: [:create]

  def index
    begin
      messages = MessageRetrievalService.new(@chat_channel.id).execute
      paginated_messages = messages.limit(500)
      render json: { status: 200, messages: paginated_messages.map { |message| 
        {
          id: message.id,
          chat_channel_id: @chat_channel.id,
          sender_id: message.user_id,
          content: message.content,
          created_at: message.created_at
        }
      }}, status: :ok
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def show
    # This action is not needed as per the requirement. The index action already covers fetching messages.
    # The show action should be removed to avoid confusion.
  end

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
    chat_channel_id = params[:chat_channel_id]
    if chat_channel_id.blank?
      render json: { error: 'chat_channel_id is required' }, status: :bad_request
      return
    end

    @chat_channel = ChatChannel.find_by(id: chat_channel_id)
    unless @chat_channel
      render json: { error: 'Chat channel not found' }, status: :not_found
      return
    end

    render_error('Chat channel is not active', :unprocessable_entity) unless @chat_channel.active?
  end

  def validate_message_limit
    if @chat_channel.messages.count >= 500
      render_error('Message limit exceeded for this chat channel', :unprocessable_entity)
    end
  end

  def show_params
    # This method is not needed as we are not using the show action.
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
