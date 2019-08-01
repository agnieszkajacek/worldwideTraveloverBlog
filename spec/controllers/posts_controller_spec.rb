require 'rails_helper'

RSpec.describe PostsController do
  let!(:published_post) { create(:post, title: 'City break', slug: 'city-break', published: 2.days.ago) }
  let!(:published_post_1) { create(:post, published: 5.days.ago) }
  let!(:unpublished_post) { create(:post, published: 2.days.from_now) }

  describe 'GET #index' do
    it 'returns an array of only published posts' do
      get :index
      expect(assigns(:posts)).to match_array([published_post, published_post_1])
    end

    it 'returns an array of only published and ordered posts' do
      get :index
      expect(assigns(:posts)).to eq([published_post, published_post_1])
    end

    it 'paginates results' do
      5.times do
        create(:post, published: 6.days.ago)
      end

      get :index, params: { page: 1 }
      expect(assigns(:posts).length).to eq(6)

      get :index, params: { page: 2 }
      expect(assigns(:posts).length).to eq(1)
    end

    it 'allows searching posts by title' do
      get :index, params: { search: 'City break'}
      expect(assigns(:posts)).to eq([published_post])
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template('index')
    end

    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested post to @post' do
      get :show, params: { id: published_post.id }

      expect(assigns(:post)).to eq(published_post)
    end

    it 'renders the :show template' do
      get :show, params: { id: published_post.id }
      expect(response).to render_template('show')
    end

    it "has a 200 status code" do
      get :show, params: { id: published_post.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #new' do
    login_user

    it 'creates new post and assigns it to @post' do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end

    it 'renders the :new template' do
      get :new 
      expect(response).to render_template('new')
    end

    it "has a 200 status code" do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #edit' do
    login_user
  end

  describe 'POST #create' do
    login_user

    context 'with valid attributes' do
      let!(:category) { create(:category) }
      let!(:new_post) { attributes_for(:post, category_id: category) }

      it 'saves the new post in the database' do
        expect {
          post :create, params: { post: new_post }
        }.to change(Post, :count).by(1)
      end

      it 'sends email notification to subscribers' do
        subscribers = 2.times.map do
          create(:subscriber, subscription: true)
        end
        
        fake_mail = double
        expect(fake_mail).to receive(:deliver_later).with(wait_until: be_within(1.second).of(Time.zone.now))
        expect(NotificationMailer).to receive(:post_email).with(subscribers[0], kind_of(Post)).once.and_return(fake_mail)

        fake_mail_2 = double
        expect(fake_mail_2).to receive(:deliver_later).with(wait_until: be_within(1.second).of(Time.zone.now + 15.minutes))

        expect(NotificationMailer).to receive(:post_email).with(subscribers[1], kind_of(Post)).once.and_return(fake_mail_2)
        
        post :create, params: { post: new_post }
      end

      it 'redirects to the post page' do
        post :create, params: { post: new_post }
        expect(response).to redirect_to(Post.last)
        expect(response.status).to eq(302)
      end
    end
    
    context 'with invalid attributes' do
      let!(:category) { create(:category) }
      let!(:new_post) { attributes_for(:post, category_id: nil) }
      
      it 'does not save the new post in the database' do
        expect {
          post :create, params: { post: new_post }
        }.not_to change(Post, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { post: new_post }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user

    it 'deletes the post and returns a 302 status code for redirect' do
      expect {
        delete :destroy, params: { id: published_post.id }
      }.to change(Post, :count).by(-1)

      expect(response.status).to eq(302)
    end
      
    it 'redirects to posts#index' do
      delete :destroy, params: { id: published_post.id }
      expect(response).to redirect_to(root_path)
    end
  end

end
