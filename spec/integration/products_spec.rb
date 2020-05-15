require 'swagger_helper'

describe 'Avenida Challenge API' do

  path '/api/v1/products' do
    post 'Creates a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object, properties: {
              title: { type: :string },
              description: { type: :string },
              stock: { type: :integer},
              price: { type: :number },
              state: { type: :string }
            }
          }
        },
        required: [ 'title', 'description', 'stock', 'price', 'state' ]
      }

      response '201', 'created' do
        let(:product) do
          {
            "title": "Draft notebook",
            "description": "Double, blue",
            "stock": 20,
            "price": 20.5,
            "state": "hidden"
          } 
        end
        run_test!
      end

      response '400', 'bad request' do
        let(:product) { { title: 'foo' } }
        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do

    get 'Retrieves a product' do
      tags 'Products'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'OK' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          title: { type: :string },
          description: { type: :string },
          stock: { type: :integer},
          price: { type: :number },
          state: { type: :string }
        }

        let(:id) do
          Product.create(title: 'Draft notebook',
                         description: 'Double, blue',
                         stock: 20,
                         price: 20.5,
                         state: 'hidden').id
        end

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/products' do
    get 'List products' do
      tags 'Products'
      consumes 'application/json', 'application/xml'
      produces 'application/json'
      parameter name: :products, in: :body, schema: {
        type: :array,
        items: {
          properties: {
            title: { type: :string },
            description: { type: :string },
            stock: { type: :integer},
            price: { type: :number },
            state: { type: :string }
          }
        }
      }

      response '200', 'OK' do
        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do
    patch 'Edit a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'OK' do
        schema type: :object,
        properties: {
          product: {
            type: :object, properties: {
              title: { type: :string },
              description: { type: :string }
            }
          }
        }


        let(:id) do
          Product.create(title: 'Draft notebook',
                         description: 'Double, blue',
                         stock: 20,
                         price: 20.5,
                         state: 'hidden').id
        end

        run_test!
      end

      response '400', 'bad request' do
        let(:product) { { title: '' } }
        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do
    delete 'Delete a product' do
      tags 'Products'
      parameter name: :id, in: :path, type: :string

      response '200', 'OK' do
        let(:id) do
          Product.create(title: 'Draft notebook',
                         description: 'Double, blue',
                         stock: 20,
                         price: 20.5,
                         state: 'hidden').id
        end

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
