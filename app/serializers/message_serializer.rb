# frozen_string_literal: true

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :chat_channel_id, :user_id, :content, :created_at

  def created_at
    object.created_at.iso8601
  end
end

