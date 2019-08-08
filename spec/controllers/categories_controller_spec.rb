require 'rails_helper'

RSpec.describe CategoriesController do
  let!(:thailand_category) { create(:category) }
  let!(:italy_category) { create(:category, name: "Italy", created_at: 2.days.from_now) }

  describe 'GET #index' do
    context 'when user is logged_in' do
      login_user
      
      it 'returns an array of all categories' do
        get :index
        expect(assigns(:categories)).to match_array([thailand_category, italy_category])
      end
  
      it 'returns ordered categories' do 
        get :index
        expect(assigns(:categories).count).to eq(2)
        expect(assigns(:categories).to_a).to eq([italy_category, thailand_category])
      end
  
      it 'returns the :index view' do
        get :index
        expect(response.status).to eq(200)
        expect(response).to render_template('index')
      end
    end
    
    context 'when user is not logged_in' do
      it 'redirects to user_session_path' do
        get :index
        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'GET #show' do
    let!(:thailand_post) { create(:post, category_id: thailand_category.id) }

    let!(:italy_post_bergamo) { create(:post, title: "Bergamo", category_id: italy_category.id, created_at: 5.days.ago) }

    let!(:italy_post_milano) { create(:post, title: "Milano", category_id: italy_category.id, created_at: 2.days.ago) }

    it 'assigns the requested category to @category' do
      get :show, params: { id: thailand_category.id }

      expect(assigns(:category)).to eq(thailand_category)
    end

    it 'searches for posts with specific categry_id' do
      get :show, params: { id: italy_category.id }

      expect(assigns(:posts).count).to eq(2)
      expect(assigns(:posts)).to match_array([italy_post_bergamo, italy_post_milano])
    end

    it 'returns ordered posts' do
      get :show, params: { id: italy_category.id }

      expect(assigns(:posts).to_a).to eq([italy_post_milano, italy_post_bergamo])     
    end

    it 'renders the :index view' do
      get :show, params: { id: thailand_category.id }

      expect(response).to render_template('show')
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #new' do 
    context 'when user is logged in' do
      login_user

      it 'creates new category and assigns it to @category' do
        get :new

        expect(assigns(:category)).to be_a_new(Category)
      end

      it 'renders the :new template' do
        get :new 

        expect(response).to render_template('new')
        expect(response.status).to eq(200)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to user_session_path' do
        get :new

        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is logged in' do
      login_user

      it 'assigns @category' do
        get :edit, params: { id: thailand_category.id }

        expect(assigns(:category)).to eq(thailand_category)
      end

      it "renders the :edit template" do
        get :edit, params: { id: thailand_category.id }

        expect(response).to render_template("edit")
        expect(response.status).to eq(200)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to user_session_path' do
        get :edit, params: { id: thailand_category.id }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end 

  describe 'POST #create' do 
    context 'when user is logged in' do
      login_user

      context 'with valid attributes' do
        let!(:valid_params) { attributes_for(:category, name: 'Poland') }

        it 'creates new category' do
          expect {
            post :create, params: { 
              category: valid_params
            }
          }.to change(Category, :count).by(1)
        end

        it 'redirects to categories page' do
          post :create, params: { category: valid_params }
          expect(response).to redirect_to(categories_path)
          expect(response.status).to eq(302)
        end
      end

      context 'with invalid attributes' do
        let!(:invalid_params) { attributes_for(:category, name: '') }

        it 'does not create new category' do
          expect {
            post :create, params: { category: invalid_params }
          }.not_to change(Category, :count)
        end

        it 're-renders the :new template' do
          post :create, params: { category: invalid_params }
          expect(response).to render_template('new')
        end

      end
    end

    context 'when user is not logged in' do
      it 'redirects to user_session_path' do
        post :create, params: { category: attributes_for(:category) }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'PUT #update' do
    context 'when user is logged in' do
      login_user

      context 'with valid attributes' do
        it 'updates attributes and redirects to category' do
          put :update, params: {
            category: {
              name: "Kingdom of Thailand"
            },
            id: thailand_category.id
          }

          expect(thailand_category.reload.name).to eq('Kingdom of Thailand')
          expect(response).to redirect_to("/categories/#{thailand_category.slug}")
        end
      end

      context 'with invalid attributes' do
        it 'updates attributes and redirects to category' do
          put :update, params: {
            category: {
              name: ""
            },
            id: thailand_category.id
          }

          expect(response).to render_template('edit')
        end
      end
    end

    context 'when user is not logged_in' do
      it 'redirects to user_session_path' do
        post :update, params: { category: attributes_for(:category), id: thailand_category.id }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged_in' do
      login_user
    
      it 'deletes the category and returns a 302 status code for redirect' do
        expect {
          delete :destroy, params: { id: thailand_category.id }
        }.to change(Category, :count).by(-1)
    
        expect(response.status).to eq(302)
      end
          
      it 'redirects to posts#index' do
        delete :destroy, params: { id: thailand_category.id }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged_in' do
      it 'redirects to user_session_path' do
        delete :destroy, params: { id: thailand_category.id }
      
        expect(response.status).to eq(302)
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
end
