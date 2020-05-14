module Api
  module V1
    class ClientsController < ApplicationController
      def index
        clients = Client.all
        render json: clients, status: :ok
      end

      def show
        render json: client, status: :ok
      end

      def create
        client = Client.create(client_params)
        return bad_request(client.errors) unless client.errors.blank?

        render json: client, status: :created
      end

      def update
        return bad_request(client.errors) unless client.update(client_params)

        render json: client, status: :ok
      end

      def destroy
        client.destroy

        head :ok
      end

      private

      def client
        Client.find(params[:id])
      end

      def client_params
        params.require(:client).permit(:email, :name, :dni, :phone_number, :address)
      end
    end
  end
end
