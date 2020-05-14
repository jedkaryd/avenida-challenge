module Api
  module V1
    class ProductsController < ApplicationController
      def index
        products = Product.all_visible_ones
        render json: products, status: :ok
      end

      def show
        render json: product, status: :ok
      end

      def create
        product = Product.create(product_params)
        return bad_request(product.errors) unless product.errors.blank?

        render json: product, status: :created
      end

      def update
        return bad_request(product.errors) unless product.update(product_params)

        render json: product, status: :ok
      end

      def destroy
        product.destroy

        head :ok
      end

      private

      def product
        Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:title, :stock, :price, :state, :description)
      end
    end
  end
end
