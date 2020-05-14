module Api
  module V1
    class OrdersController < ApplicationController
      def index
        orders = Order.all
        render json: orders, status: :ok
      end

      def show
        render json: order, status: :ok
      end

      def create
        order = Order.create(order_params)
        return bad_request(order.errors) unless order.errors.blank?

        render json: order, status: :created
      end

      def update
        return bad_request(order.errors) unless order.update(order_params)

        render json: order, status: :ok
      end

      def destroy
        order.destroy

        head :ok
      end

      private

      def order
        Order.find(params[:id])
      end

      def order_params
        params.require(:order).permit(:client_id, product_ids: [])
      end
    end
  end
end
