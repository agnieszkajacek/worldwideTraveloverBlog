# frozen_string_literal: true

class ContactController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new contact_params

    if @contact.valid?
      ContactUsMailer.general_message(@contact).deliver_now
      redirect_to root_path, notice: t('notice.ok_message')
    else
      redirect_to contact_new_path, alert: t('alert.failed_message')
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :body)
  end
end
