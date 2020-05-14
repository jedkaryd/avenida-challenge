require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe 'GET #index' do
    context 'when there are products created' do
      before do
        create_list(:product, 5)
        create_list(:product, 2, state: 'hidden')
        get :index
      end

      let(:visible_products_count) { 5 }

      it 'responds with a not empty array' do
        expect(response_body).not_to be_empty
      end

      it 'responds with the list of visible products' do
        response_body.each do |product|
          expect(product[:state]).to eq('visible')
        end
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with all visible the products' do
        expect(response_body.length).to eq visible_products_count
      end
    end

    context 'when there are not products created' do
      before { get :index }

      it 'returns an empty array' do
        expect(response_body).to eq([])
      end

      it 'responds with status ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #show' do
    context 'when given a correct ID' do
      let!(:product) { create(:product) }

      before do
        get :show, params: { id: product.id }
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with a product json' do
        expect(response.body).to eq ProductSerializer.new(
          product
        ).to_json
      end
    end

    context 'when given a non-existent ID' do
      before do
        get :show, params: { id: 1 }
      end

      it 'responds with an error message' do
        expect(response_body).to have_key(:error)
      end

      it 'responds with 404 status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    subject(:create_product) do
      post :create, params: { product: request_params }
    end

    context 'with correct params' do
      let(:request_params) { attributes_for(:product) }

      it 'creates the product' do
        expect { create_product }.to change { Product.count }.by(1)
      end

      it 'responds with status created' do
        create_product
        expect(response).to have_http_status(:created)
      end
    end

    context 'with wrong params' do
      let(:request_params) { { title: '' } }

      it 'does not create the product' do
        expect { create_product }.not_to change(Product, :count)
      end

      it 'responds with bad request' do
        create_product
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PATCH #update' do
    let(:product) { create(:product) }

    subject(:update_product) do
      patch :update, params: { id: product.id, product: request_params }
      product.reload
    end

    context 'with correct params' do
      let(:request_params) { { title: 'new title' } }

      it 'updates the product' do
        update_product
        expect(product.title).to eql(request_params[:title])
      end

      it 'responds with status ok' do
        update_product
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with wrong params' do
      let(:request_params) { { title: '' } }

      it 'does not update the product' do
        update_product
        expect(product).to eql(Product.find(product.id))
      end

      it 'responds with bad request' do
        update_product
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with an invalid product id' do
      subject(:update_product) do
        patch :update, params: { id: 5, product: request_params }
      end

      let(:request_params) { { title: 'new title' } }

      it 'responds with not found' do
        update_product
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        update_product
        expect(response_body).to have_key(:error)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when given a correct ID' do
      let!(:product) { create(:product) }

      subject(:delete_product) do
        delete :destroy, params: { id: product.id }
      end

      it 'removes the product' do
        expect { delete_product }.to change { Product.count }.by(-1)
      end

      it 'responds with 200 status' do
        delete_product
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when given a non-existent ID' do
      subject(:delete_product) do
        delete :destroy, params: { id: 1 }
      end

      it 'does not removes the product' do
        expect { delete_product }.not_to change(Product, :count)
      end

      it 'responds with an error message' do
        delete_product
        expect(response_body).to have_key(:error)
      end

      it 'responds with 404 status' do
        delete_product
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
