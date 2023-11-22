require 'swagger_helper'

RSpec.describe 'User', type: :request do
  # jitera-hook-for-rswag-example

  path '/api/users/{id}' do
    put 'Update  users' do
      tags 'users'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          users: {
            type: :object,
            properties: {

              email: {

                type: :string

              }

            }
          }

        }
      }
      response '200', 'update' do
        examples 'application/json' => {

          'user' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'email' => 'STRING',

            'products' => 'ARRAY',

            'bid_items' => 'ARRAY',

            'bids' => 'ARRAY',

            'wallet' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'balance' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'deposits' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { create(:user) }

        let(:params) { { users: resource.attributes.to_hash } }

        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
  path '/api/users/{id}' do
    get 'Show users' do
      tags 'users'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'user' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'email' => 'STRING',

            'products' => 'ARRAY',

            'bid_items' => 'ARRAY',

            'bids' => 'ARRAY',

            'wallet' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'balance' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'deposits' => 'ARRAY'

          },

          'message' => {}

        }

        let(:resource) { create(:user) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/users' do
    post 'Create users' do
      tags 'users'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          users: {
            type: :object,
            properties: {

              email: {

                type: :string

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'user' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'email' => 'STRING',

            'products' => 'ARRAY',

            'bid_items' => 'ARRAY',

            'bids' => 'ARRAY',

            'wallet' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'balance' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'deposits' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { build(:user) }

        let(:params) { { users: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/users' do
    get 'List users' do
      tags 'users'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :url, schema: {
        type: :object,
        properties: {

          pagination_page: {

            type: :page_number

          },

          pagination_limit: {

            type: :page_size

          },

          users: {
            type: :object,
            properties: {

              email: {

                type: :string

              }

            }
          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'users' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:user) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
