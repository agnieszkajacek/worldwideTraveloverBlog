# frozen_string_literal: true

class ContactUsMailer < ApplicationMailer
  default to: ENV['WT_EMAIL']

  def general_message(contact)
    @contact = contact
    mail(
      from: @contact.email,
      reply_to: @contact.email,
      subject: 'Ktoś wysłał nową wiadomość'
    )
  end
end
