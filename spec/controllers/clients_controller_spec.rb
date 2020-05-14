require 'rails_helper'

RSpec.describe Api::V1::ClientsController, type: :controller do
  describe 'GET #index' do
    context 'when there are clients created' do
      let!(:clients) { create_list(:client, 5) }

      before do
        get :index
      end

      it 'responds with a not empty array' do
        expected = JSON.parse(response.body)
        expect(expected).not_to be_empty
      end

      it 'responds with the lists of client' do
        expected = ActiveModel::Serializer::CollectionSerializer.new(
          clients, serializer: ClientSerializer
        ).to_json
        expect(response.body).to eq expected
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with all the clients' do
        expected = JSON.parse(response.body)
        expect(expected.length).to eq clients.count
      end
    end

    context 'when there are not clients created' do
      before { get :index }

      it 'returns an empty array' do
        expected = JSON.parse(response.body)
        expect(expected).to eq([])
      end

      it 'responds with status ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #show' do
    context 'when given a correct ID' do
      let!(:client) { create(:client) }

      before do
        get :show, params: { id: client.id }
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with a client json' do
        expect(response.body).to eq ClientSerializer.new(
          client
        ).to_json
      end
    end

    context 'when given a non-existent ID' do
      before do
        get :show, params: { id: 1 }
      end

      it 'responds with an error message' do
        expected = JSON.parse(response.body)
        expect(expected).to have_key('error')
      end

      it 'responds with 404 status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    subject(:create_client) do
      post :create, params: { client: request_params }
    end

    context 'with correct params' do
      let(:request_params) { attributes_for(:client) }

      it 'creates the client' do
        expect { create_client }.to change { Client.count }.by(1)
      end

      it 'responds with status created' do
        create_client
        expect(response).to have_http_status(:created)
      end
    end

    context 'with wrong params' do
      let(:request_params) { { name: '' } }

      it 'does not create the client' do
        expect { create_client }.not_to change(Client, :count)
      end

      it 'responds with bad request' do
        create_client
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PATCH #update' do
    let(:client) { create(:client) }

    subject(:update_client) do
      patch :update, params: { id: client.id, client: request_params }
      client.reload
    end

    context 'with correct params' do
      let(:request_params) { { name: 'new name' } }

      it 'updates the client' do
        update_client
        expect(client.name).to eql(request_params[:name])
      end

      it 'responds with status ok' do
        update_client
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with wrong params' do
      let(:request_params) { { name: '' } }

      it 'does not update the client' do
        update_client
        expect(client).to eql(Client.find(client.id))
      end

      it 'responds with bad request' do
        update_client
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with an invalid client id' do
      let(:client) { create(:client) }

      subject(:update_client) do
        patch :update, params: { id: 5, client: request_params }
        client.reload
      end

      let(:request_params) { { name: 'new name' } }

      it 'responds with not found' do
        update_client
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        update_client
        expected = JSON.parse(response.body)
        expect(expected).to have_key('error')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when given a correct ID' do
      let!(:client) { create(:client) }

      subject(:delete_client) do
        delete :destroy, params: { id: client.id }
      end

      it 'removes the client' do
        expect { delete_client }.to change { Client.count }.by(-1)
      end

      it 'responds with 200 status' do
        delete_client
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when given a non-existent ID' do
      subject(:delete_client) do
        delete :destroy, params: { id: 1 }
      end

      it 'does not removes the client' do
        expect { delete_client }.not_to change(Client, :count)
      end

      it 'responds with an error message' do
        delete_client
        expected = JSON.parse(response.body)
        expect(expected).to have_key('error')
      end

      it 'responds with 404 status' do
        delete_client
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
