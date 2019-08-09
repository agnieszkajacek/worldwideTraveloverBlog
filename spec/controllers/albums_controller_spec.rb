require 'rails_helper'

RSpec.describe AlbumsController do
  describe 'GET #show' do
    let!(:first_category) { create(:category) }
    let!(:second_category) { create(:category, name: 'Italy') }

    let!(:first_photo) { create(:photo, category_id: first_category.id, tag: 'thailand', public: true) }
    let!(:second_photo) { create(:photo, name: "Bergamo", category_id: second_category.id, tag: 'italy', created_at: 5.days.ago, public: true) }
    let!(:last_photo) { create(:photo, name: "Milano", category_id: second_category.id, tag: 'italy', created_at: 2.days.ago, public: false) }

    context 'when user is not logged_in' do
      it 'assigns requested category to @category' do
        get :show, params: { id: first_category.id }

        expect(assigns(:category)).to eq(first_category)
      end

      it 'shows only public photos for specific category id' do
        get :show, params: { id: second_category.id }

        expect(assigns(:photos).count).to eq(1)
        expect(assigns(:photos)).to match_array([second_photo])
      end

      it 'assigns requested unig_tags to @uniq_tags' do
        get :show, params: { id: second_category.id }

        expect(assigns(:uniq_tags)).to eq(['italy'])
      end

      it 'returns a hash array with tag_name and number' do
        get :show, params: { id: second_category.id }

        expect(assigns(:tags)).to eq([{tag_name: 'italy', number: 1}])
      end

      it 'returns photos with specific tag' do
        get :show, params: { id: second_category.id, tag: 'italy' }

        expect(assigns(:photos).count).to eq(1)
        expect(assigns(:photos)).to match_array([second_photo])
      end

      it 'renders the :show template' do
        get :show, params: { id: second_category.id }
        
        expect(response).to render_template('show')
        expect(response.status).to eq(200)
      end
    end

    context 'when user is logged_in' do
      login_user

      it 'shows public and not public photos for specific category id' do
        get :show, params: { id: second_category.id }

        expect(assigns(:photos).count).to eq(2)
        expect(assigns(:photos)).to match_array([second_photo, last_photo])
      end
    end
  end
end
