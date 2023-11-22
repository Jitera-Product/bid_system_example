require 'swagger_helper'

RSpec.describe 'Deposit', type: :request do
  # jitera-hook-for-rswag-example
  path '/api/deposits/{id}' do
    get 'Show deposits' do
      tags 'deposits'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'deposit' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'value' => 'INTEGER',

            'user' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'email' => 'STRING'

            },

            'user_id' => 'INTEGER',

            'wallet' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'balance' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'wallet_id' => 'INTEGER',

            'status' => 'STRING',

            'payment_method' => {

              'user_id' => 'INTEGER',

              'primary' => 'BOOLEAN',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'method' => 'STRING'

            },

            'payment_method_id' => 'INTEGER'

          },

          'message' => {}

        }

        let(:resource) { create(:deposit) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/deposits' do
    post 'Create deposits' do
      tags 'deposits'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          deposits: {
            type: :object,
            properties: {

              value: {

                type: :integer

              },

              user_id: {

                type: :integer

              },

              wallet_id: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[new inprogress done fail]

              },

              payment_method_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'deposit' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'value' => 'INTEGER',

            'user' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'email' => 'STRING'

            },

            'user_id' => 'INTEGER',

            'wallet' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'balance' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'wallet_id' => 'INTEGER',

            'status' => 'STRING',

            'payment_method' => {

              'user_id' => 'INTEGER',

              'primary' => 'BOOLEAN',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'method' => 'STRING'

            },

            'payment_method_id' => 'INTEGER'

          },

          'error_object' => {}

        }

        let(:resource) { build(:deposit) }

        let(:params) { { deposits: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/deposits' do
    get 'List deposits' do
      tags 'deposits'
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

          deposits: {
            type: :object,
            properties: {

              value: {

                type: :integer

              },

              user_id: {

                type: :integer

              },

              wallet_id: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[new inprogress done fail]

              },

              payment_method_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'deposits' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:deposit) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
