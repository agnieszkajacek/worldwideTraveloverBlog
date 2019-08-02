require 'rails_helper'

RSpec.describe PhotosController do
  let!(:category) { create(:category) }
  let!(:photo) { create(:photo) }
  let!(:new_photo) { attributes_for(:photo, category_id: category) }

  describe 'GET #index' do
    it 'should run the find_categories method' do
      photo_obj = described_class.new
      expect(photo_obj).to receive(:find_categories)
      photo_obj.index
    end

    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'should run the find_photo method' do
      photo_obj = described_class.new
      expect(photo_obj).to receive(:find_photo)
      photo_obj.show
    end

    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end
  
  describe 'GET #new' do 
    login_user

    it 'creates new photo and assings it to @photo' do
      get :new
      expect(assigns(:photo)).to be_a_new(Photo)
    end

    it 'should run the categories method' do
      photo_obj = described_class.new
      expect(photo_obj).to receive(:find_categories)
      photo_obj.new
    end
  end

  describe 'GET #edit' do 
    login_user

    it 'should run the find_photo method' do
      photo_obj = described_class.new
      expect(photo_obj).to receive(:find_photo)
      photo_obj.show
    end

    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      it 'saves new photo to the database' do
        expect {
          post :create, params: { photo: new_photo }
        }.to change(Photo, :count).by(1)
      end

      it 'redirects to the photos page' do
        post :create, params: { photo: new_photo }
        expect(response).to redirect_to(photos_path)
        expect(response.status).to eq(302)
      end
    end

    context 'with ininvalid attributes' do
      let!(:new_photo) { attributes_for(:post, category_id: nil) }
      
      it 'does not save the new post in the database' do
        expect {
          post :create, params: { photo: new_photo }
        }.not_to change(Photo, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { photo: new_photo }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    login_user
    context ' with valid attributes' do
      it 'chanages @photos\'s atrributes' do
        put :update, params: {
          photo: {
            name: "New name for photo"
          },
          id: photo.id
        }

        expect(photo.reload.name).to eq("New name for photo")
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

  describe 'DELETE #destroy' do
  login_user

  it 'deletes the photo and returns a 302 status code for redirect' do
    expect {
      delete :destroy, params: { id: photo.id }
    }.to change(Photo, :count).by(-1)

    expect(response.status).to eq(302)
  end
    
  it 'redirects to posts#index' do
    delete :destroy, params: { id: photo.id }
    expect(response).to redirect_to(root_path)
  end
end
end
