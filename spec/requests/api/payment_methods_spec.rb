require 'swagger_helper'

RSpec.describe 'PaymentMethod', type: :request do
  # jitera-hook-for-rswag-example
  path '/api/payment_methods/{id}' do
    get 'Show payment_methods' do
      tags 'payment_methods'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'wallet' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'user_id' => 'INTEGER',

            'primary' => 'BOOLEAN',

            'method' => 'STRING',

            'payment_method_withdrawal' => {

              'value' => 'INTEGER',

              'status' => 'STRING',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'aprroved_id' => 'INTEGER',

              'payment_method_id' => 'INTEGER'

            },

            'deposits' => 'ARRAY'

          },

          'message' => {}

        }

        let(:resource) { create(:payment_method) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/payment_methods' do
    post 'Create payment_methods' do
      tags 'payment_methods'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          wallets: {
            type: :object,
            properties: {

              user_id: {

                type: :integer

              },

              primary: {

                type: :boolean

              },

              method: {

                type: 'string',
                enum: %w[paypal usdt stripe]

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'wallet' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'user_id' => 'INTEGER',

            'primary' => 'BOOLEAN',

            'method' => 'STRING',

            'payment_method_withdrawal' => {

              'value' => 'INTEGER',

              'status' => 'STRING',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'aprroved_id' => 'INTEGER',

              'payment_method_id' => 'INTEGER'

            },

            'deposits' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { build(:payment_method) }

        let(:params) { { wallets: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/payment_methods' do
    get 'List payment_methods' do
      tags 'payment_methods'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :url, schema: {
        type: :object,
        properties: {

          wallets: {
            type: :object,
            properties: {

              user_id: {

                type: :integer

              },

              primary: {

                type: :boolean

              },

              method: {

                type: 'string',
                enum: %w[paypal usdt stripe]

              }

            }
          },

          pagination_page: {

            type: :page_number

          },

          pagination_limit: {

            type: :page_size

          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'wallets' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:payment_method) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
