require 'swagger_helper'

describe 'Avenida Challenge API' do

  path '/api/v1/orders' do
    post 'Creates an order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          order: {
            type: :object, properties: {
              client_id: { type: :integer },
              product_ids: {
                type: :array,
                items: {
                  type: :integer
                }
             },
            }
          }
        },
        required: [ 'client_id' ]
      }

      response '201', 'created' do
        let(:order) do
          {
            "client_id": 1,
            "product_ids": [1,2,3]
          } 
        end
        run_test!
      end

      response '400', 'bad request' do
        let(:order) { { client_id: 'foo' } }
        run_test!
      end
    end
  end

  path '/api/v1/orders/{id}' do

    get 'Retrieves a order' do
      tags 'Orders'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'OK' do
        schema type: :object,
        properties: {
          type: :object, properties: {
            client_id: { type: :integer },
            product_ids: {
              type: :array,
              items: {
                type: :integer
              }
            },
          }
        }

        let(:client) { Client.create(name: 'Pedro Perez', email: 'pedrop@gmail.com', dni: 12345678) }
        let(:product) do
          Product.create(title: 'Draft notebook',
          description: 'Double, blue',
          stock: 20,
          price: 20.5,
          state: 'hidden')
        end
        let(:id) do
          Order.create(client_id: client.id, product_ids: [product.id]).id
        end

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/orders' do
    get 'List orders' do
      tags 'Orders'
      consumes 'application/json', 'application/xml'
      produces 'application/json'
      parameter name: :orders, in: :body, schema: {
        type: :array,
        items: {
          properties: {
            type: :object, properties: {
              client_id: { type: :integer },
              product_ids: {
                type: :array,
                items: {
                  properties: {
                    type: :integer
                  }
                }
              },
            }
          }
        }
      }

      response '200', 'OK' do
        run_test!
      end
    end
  end

  path '/api/v1/orders/{id}' do
    patch 'Edit a order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'OK' do
        schema type: :object,
        properties: {
          order: {
            type: :object, properties: {
              client_id: { type: :integer },
              product_ids: {
                type: :array,
                items: {
                  type: :integer
                }
              },
            }
          }
        }

        let(:client) { Client.create(name: 'Pedro Perez', email: 'pedrop@gmail.com', dni: 12345678) }
        let(:product) do
          Product.create(title: 'Draft notebook',
          description: 'Double, blue',
          stock: 20,
          price: 20.5,
          state: 'hidden')
        end
        let(:id) do
          Order.create(client_id: client.id, product_ids: [product.id]).id
        end

        run_test!
      end

      response '400', 'bad request' do
        let(:order) { { client_id: '' } }
        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/orders/{id}' do
    delete 'Delete a order' do
      tags 'Orders'
      parameter name: :id, in: :path, type: :string

      response '200', 'OK' do
        let(:client) { Client.create(name: 'Pedro Perez', email: 'pedrop@gmail.com', dni: 12345678) }
        let(:product) do
          Product.create(title: 'Draft notebook',
          description: 'Double, blue',
          stock: 20,
          price: 20.5,
          state: 'hidden')
        end
        let(:id) do
          Order.create(client_id: client.id, product_ids: [product.id]).id
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
