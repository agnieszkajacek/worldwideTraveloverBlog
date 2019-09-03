# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscriber do
  before(:each) do
    @subscriber = build(:subscriber)
  end

  describe 'validations' do
    context 'when email format is valid' do
      it 'should be valid' do
        valid_emails = [
          'email@example.com',
          'firstname.lastname@example.com',
          'email@subdomain.example.com',
          'firstname+lastname@example.com',
          '1234567890@example.com',
          'email@example-one.com',
          '_______@example.com',
          'email@example.name',
          'email@example.museum',
          'email@example.co.jp',
          'firstname-lastname@example.com'
        ]

        valid_emails.each do |ve|
          @subscriber.email = ve
          expect(@subscriber).to be_valid
        end
      end
    end

    context 'when email format is invalid' do
      it 'should be invalid' do
        invalid_emails = [
          'plainaddress',
          '#@%^%#$@#$@#.com',
          '@example.com',
          'Joe Smith <email@example.com>',
          'email.example.com',
          'email@example@example.com',
          'email@example.com (Joe Smith)',
          'email@example',
          'email@111.222.333.44444',
          'email@example..com',
          '”(),:;<>[\]@example.com',
          'just”not”right@example.com',
          'this\ is"really"not\allowed@example.com'
        ]

        invalid_emails.each do |ie|
          @subscriber.email = ie
          expect(@subscriber).not_to be_valid
        end
      end
    end

    describe '#add_unsubscribe_hash' do
      it 'verifies that add_unsubscribe_hash is called' do
        expect(@subscriber).to receive(:add_unsubscribe_hash)
        @subscriber.save
      end

      it 'verifies the result is set' do
        @subscriber.save
        expect(@subscriber.unsubscribe_hash).not_to be_empty
      end
    end
  end
end
