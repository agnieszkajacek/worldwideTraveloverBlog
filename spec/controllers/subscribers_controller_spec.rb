# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscribersController do
  let(:recaptcha_score) { 0.6 }
  let(:recaptcha_success) { true }

  before(:each) do
    stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify')
      .with(query: {
              secret: ENV['RECAPTCHA_PRIVATE_KEY'],
              response: 'fake1254'
            }).to_return(
              status: 200,
              body: {
                score: recaptcha_score,
                success: recaptcha_success
              }.to_json,
              headers: { 'Content-Type' => 'application/json' }
            )
  end

  describe 'POST #create' do
    context 'when user is not human' do
      let(:recaptcha_score) { 0.4 }

      it 'does not create subscriber ' do
        expect do
          post :create, params: {
            subscriber: {
              email: 'test@test.com',
              subscription: true,
              recaptcha_token: 'fake1254'
            }
          }
        end.not_to change(Subscriber, :count)

        expect(flash[:notice]).to eq('Wygląda na to, że jesteś botem :(')
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is human' do
      it 'checks if subscriber is active' do
        create(:subscriber, email: 'test@test.com', subscription: true)

        post :create, params: {
          subscriber: {
            email: 'test@test.com',
            subscription: true,
            recaptcha_token: 'fake1254'
          }
        }

        expect(flash[:notice]).to eq('Wygląda na to, że już ze mną jesteś na bieżąco :)')
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
      end

      it 'checks if the user has subscribed to the newsletter again' do
        inactive_subscriber = create(:subscriber, email: 'test@test.com', subscription: false)

        post :create, params: {
          subscriber: {
            email: 'test@test.com',
            recaptcha_token: 'fake1254'
          }
        }

        expect(inactive_subscriber.reload.subscription).to eq(true)
        expect(response.status).to eq(302)
        expect(flash[:notice]).to eq('Witamy ponownie! :)')
      end

      it 'creates subscriber and saves cookies' do
        expect do
          post :create, params: {
            subscriber: {
              email: 'test@test.com',
              recaptcha_token: 'fake1254'
            }
          }
        end.to change(Subscriber, :count).by(1)

        expect(response.cookies['saved_subscriber']).to eq('true')

        expect(response.status).to eq(302)
        expect(flash[:notice]).to eq('Hura! Udało Ci się zapisać do newslettera!')
      end

      it 'sends notification mailer' do
        fake_email = double

        expect(fake_email).to receive(:deliver_now)

        expect(NotificationMailer).to receive(:welcome_email).with(kind_of(Subscriber)).once.and_return(fake_email)

        post :create, params: { subscriber: { email: 'test@test.com', subscription: true, recaptcha_token: 'fake1254' } }
      end
    end
  end

  describe '#unsubscribe' do
    context 'when unsubscribe_hash is valid' do
      it 'sets user subscription to false and removes cookies' do
        subscriber = create(:subscriber, email: 'test@test.com', subscription: true)

        expect do
          post :unsubscribe, params: { unsubscribe_hash: subscriber.unsubscribe_hash }
        end.to change { subscriber.reload.subscription }.from(true).to(false)

        expect(response.cookies['saved_subscriber']).to be_nil
      end
    end

    context 'when unsubscribe_hash is not valid' do
      it 'redirects to root_path and shows flash[:notice]' do
        post :unsubscribe, params: { unsubscribe_hash: 'fakeHash' }

        expect(response.status).to eq(302)
        expect(flash[:notice]).to eq('Błędny link do wypisania się z newslettera. Wypisz się krzystając z linka w mailu bądź skontaktuj się z nami.')
      end
    end
  end
end
