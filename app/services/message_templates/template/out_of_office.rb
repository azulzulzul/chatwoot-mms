class MessageTemplates::Template::OutOfOffice
  pattr_initialize [:conversation!]

  def self.perform_if_applicable(conversation)
    inbox = conversation.inbox
    return unless inbox.out_of_office?
    return if inbox.out_of_office_message.blank?

    new(conversation: conversation).perform
  end

  def perform
    ActiveRecord::Base.transaction do
      message = conversation.messages.build(out_of_office_message_params)
      attach_out_of_office_image(message)
      message.save!
    end
  rescue StandardError => e
    ChatwootExceptionTracker.new(e, account: conversation.account).capture_exception
    true
  end

  private

  delegate :contact, :account, to: :conversation

  def attach_out_of_office_image(message)
    inbox = conversation.inbox
    return unless inbox&.out_of_office_image&.attached?

    attachment = message.attachments.build(account_id: message.account_id, file_type: :image)
    attachment.file.attach(inbox.out_of_office_image.blob)
  end

  def out_of_office_message_params
    content = @conversation.inbox&.out_of_office_message

    {
      account_id: @conversation.account_id,
      inbox_id: @conversation.inbox_id,
      message_type: :template,
      content: content
    }
  end
end
