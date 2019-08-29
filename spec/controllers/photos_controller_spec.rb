# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhotosController do
  let!(:category) { create(:category) }
  let!(:photo) { create(:photo) }
  let!(:new_photo) { attributes_for(:photo, category_id: category.id) }

  describe 'GET #index' do
    it 'should run the find_categories method' do
      photo_obj = described_class.new
      expect(photo_obj).to receive(:find_categories)
      photo_obj.index
    end

    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #new' do
    context 'when user is logged_in' do
      login_user

      it 'creates new photo and assings it to @photo' do
        get :new
        expect(assigns(:photo)).to be_a_new(Photo)
      end

      it 'should run the #find_categories' do
        photo_obj = described_class.new
        expect(photo_obj).to receive(:find_categories)
        photo_obj.new
      end
    end

    context 'when user is not logged_in' do
      it 'redirects to user_session_path' do
        get :new

        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is logged_in' do
      login_user

      it 'should run the #find_categories' do
        photo_obj = described_class.new
        expect(photo_obj).to receive(:find_categories)
        photo_obj.edit
      end

      it 'renders the :edit template' do
        get :edit, params: { id: photo.id }

        expect(response).to render_template('edit')
        expect(response.status).to eq(200)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to user_session_path' do
        get :edit, params: { id: photo.id }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is logged_in' do
      login_user

      context 'with valid attributes' do
        it 'saves new photo to the database' do
          expect do
            post :create, params: { photo: new_photo }
          end.to change(Photo, :count).by(1)
        end

        it 'redirects to the photos page' do
          post :create, params: { photo: new_photo }
          expect(response).to redirect_to(photos_path)
          expect(response.status).to eq(302)
        end
      end

      context 'with ininvalid attributes' do
        let!(:new_photo) { attributes_for(:photo, category_id: nil) }

        it 'does not save the new post in the database' do
          expect do
            post :create, params: { photo: new_photo }
          end.not_to change(Photo, :count)
        end

        it 're-renders the :new template' do
          post :create, params: { photo: new_photo }
          expect(response).to render_template('new')
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to user_session_path' do
        post :create, params: { post: attributes_for(:photo) }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'PUT #update' do
    context 'when user is logged_in' do
      login_user
      context ' with valid attributes' do
        it 'chanages @photos\'s atrributes' do
          put :update, params: {
            photo: {
              name: 'New name for photo'
            },
            id: photo.id
          }

          expect(photo.reload.name).to eq('New name for photo')
        end

        it 'redirects to the photos page' do
          put :update, params: { photo: FactoryBot.attributes_for(:photo), id: photo.id }
          expect(response).to redirect_to(photos_path)
          expect(response.status).to eq(302)
        end
      end

      context ' with invalid attributes' do
        it 'does not chanages @photos\'s atrributes' do
          put :update, params: {
            photo: {
              name: nil
            },
            id: photo.id
          }

          expect(photo.reload.name).not_to eq(nil)
        end

        it 'redirects to the :edit template' do
          put :update, params: {
            photo: {
              name: nil
            },
            id: photo.id
          }

          expect(response).to render_template('edit')
        end
      end
    end

    context 'when user is not logged_in' do
      it 'redirects to user_session_path' do
        post :update, params: { photo: attributes_for(:photo), id: photo.id }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged_in' do
      login_user

      it 'deletes the photo and returns a 302 status code for redirect' do
        expect do
          delete :destroy, params: { id: photo.id }
        end.to change(Photo, :count).by(-1)

        expect(response.status).to eq(302)
      end

      it 'redirects to posts#index' do
        delete :destroy, params: { id: photo.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged_in' do
      it 'redirects to user_session_path' do
        delete :destroy, params: { id: photo.id }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
