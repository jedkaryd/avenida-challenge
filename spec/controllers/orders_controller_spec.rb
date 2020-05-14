require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  describe 'GET #index' do
    context 'when there are orders created' do
      let!(:orders) { create_list(:order, 5) }

      before do
        get :index
      end

      it 'responds with a not empty array' do
        expect(response_body).not_to be_empty
      end

      it 'responds with the lists of order' do
        expected = ActiveModel::Serializer::CollectionSerializer.new(
          orders, serializer: OrderSerializer
        ).to_json
        expect(response.body).to eq expected
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with all the orders' do
        expect(response_body.length).to eq orders.count
      end
    end

    context 'when there are not orders created' do
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
      let!(:order) { create(:order) }

      before do
        get :show, params: { id: order.id }
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with a order json' do
        expect(response.body).to eq OrderSerializer.new(
          order
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
    subject(:create_order) do
      post :create, params: { order: request_params }
    end

    context 'with correct params' do
      let(:client) { create(:client) }
      let(:products) { create_list(:product, 3) }
      let(:request_params) { { client_id: client.id, product_ids: products.pluck(:id) } }

      it 'creates the order' do
        expect { create_order }.to change { Order.count }.by(1)
      end

      it 'responds with status created' do
        create_order
        expect(response).to have_http_status(:created)
      end
    end

    context 'with wrong params' do
      let(:products) { create_list(:product, 3) }
      let(:request_params) { { client_id: 1, product_ids: products.pluck(:id) } }

      it 'does not create the order' do
        expect { create_order }.not_to change(Order, :count)
      end

      it 'responds with bad request' do
        create_order
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PATCH #update' do
    let(:order) { create(:order) }

    subject(:update_order) do
      patch :update, params: { id: order.id, order: request_params }
      order.reload
    end

    context 'with correct params' do
      let(:client) { create(:client) }
      let(:request_params) { { client_id: client.id } }

      it 'updates the order' do
        update_order
        expect(order.client_id).to eql(request_params[:client_id])
      end

      it 'responds with status ok' do
        update_order
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with wrong params' do
      let(:request_params) { { client_id: 3 } }

      it 'does not update the order' do
        update_order
        expect(order).to eql(Order.find(order.id))
      end

      it 'responds with bad request' do
        update_order
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with an invalid order id' do
      let(:client) { create(:client) }

      subject(:update_order) do
        patch :update, params: { id: 5, order: request_params }
      end

      let(:request_params) { { client_id: client.id } }

      it 'responds with not found' do
        update_order
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        update_order
        expect(response_body).to have_key(:error)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when given a correct ID' do
      let!(:order) { create(:order) }

      subject(:delete_order) do
        delete :destroy, params: { id: order.id }
      end

      it 'removes the order' do
        expect { delete_order }.to change { Order.count }.by(-1)
      end

      it 'responds with 200 status' do
        delete_order
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when given a non-existent ID' do
      subject(:delete_order) do
        delete :destroy, params: { id: 1 }
      end

      it 'does not removes the order' do
        expect { delete_order }.not_to change(Order, :count)
      end

      it 'responds with an error message' do
        delete_order
        expect(response_body).to have_key(:error)
      end

      it 'responds with 404 status' do
        delete_order
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
