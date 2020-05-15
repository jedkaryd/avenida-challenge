require 'swagger_helper'

describe 'Avenida Challenge API' do

  path '/api/v1/clients' do
    post 'Creates a client' do
      tags 'Clients'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :client, in: :body, schema: {
        type: :object,
        properties: {
          client: {
            type: :object, properties: {
              name: { type: :string },
              dni: { type: :integer },
              email: { type: :string},
              phone_number: { type: :text },
              address: { type: :string }
            }
          }
        },
        required: [ 'name', 'dni', 'email']
      }

      response '201', 'created' do
        let(:client) do
          {
            "name": "Pedro Perez",
            "email": "pedrop@gmail.com",
            "dni": 12345678,
            "phone_number": "+5491122345678",
            "address": "Av. Beiro 2500, 9A"
          } 
        end
        run_test!
      end

      response '400', 'bad request' do
        let(:client) { { name: 'foo' } }
        run_test!
      end
    end
  end

  path '/api/v1/clients/{id}' do

    get 'Retrieves a client' do
      tags 'Clients'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'OK' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string },
          email: { type: :string },
          dni: { type: :integer},
          phone_number: { type: :number },
          address: { type: :string }
        }

        let(:id) do
          Client.create(name: 'Pedro Perez',
                         email: 'pedrop@gmail.com',
                         dni: 12345678,
                         phone_number: "+5491122345678",
                         address: 'Av. Beiro 2500, 9A').id
        end

        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/clients' do
    get 'List clients' do
      tags 'Clients'
      consumes 'application/json', 'application/xml'
      produces 'application/json'
      parameter name: :clients, in: :body, schema: {
        type: :array,
        items: {
          properties: {
            name: { type: :string },
            email: { type: :string },
            dni: { type: :integer},
            phone_number: { type: :number },
            address: { type: :string }
          }
        }
      }

      response '200', 'OK' do
        run_test!
      end
    end
  end

  path '/api/v1/clients/{id}' do
    patch 'Edit a client' do
      tags 'Clients'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'OK' do
        schema type: :object,
        properties: {
          client: {
            type: :object, properties: {
              phone_number: { type: :number },
              address: { type: :string }
            }
          }
        }


        let(:id) do
          Client.create(name: 'Pedro Perez',
                         email: 'pedrop@gmail.com',
                         dni: 12345678,
                         phone_number: "+5491122345678",
                         address: 'Av. Beiro 2500, 9A').id
        end

        run_test!
      end

      response '400', 'bad request' do
        let(:client) { { title: '' } }
        run_test!
      end

      response '404', 'record not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/clients/{id}' do
    delete 'Delete a client' do
      tags 'Clients'
      parameter name: :id, in: :path, type: :string

      response '200', 'OK' do
        let(:id) do
          Client.create(name: 'Pedro Perez',
                         email: 'pedrop@gmail.com',
                         dni: 12345678,
                         phone_number: "+5491122345678",
                         address: 'Av. Beiro 2500, 9A').id
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
