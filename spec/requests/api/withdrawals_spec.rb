require 'swagger_helper'

RSpec.describe 'Withdrawal', type: :request do
  # jitera-hook-for-rswag-example
  path '/api/withdrawals/{id}' do
    get 'Show withdrawals' do
      tags 'withdrawals'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'withdraw' => {

            'status' => 'STRING',

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'value' => 'INTEGER',

            'aprroved' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'email' => 'STRING'

            },

            'aprroved_id' => 'INTEGER',

            'payment_method' => {

              'user_id' => 'INTEGER',

              'primary' => 'BOOLEAN',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'payment_method' => 'STRING'

            },

            'payment_method_id' => 'INTEGER'

          },

          'message' => {}

        }

        let(:resource) { create(:withdrawal) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/withdrawals' do
    post 'Create withdrawals' do
      tags 'withdrawals'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          withdrawals: {
            type: :object,
            properties: {

              status: {

                type: 'string',
                enum: %w[inprogress ready done]

              },

              value: {

                type: :integer

              },

              aprroved_id: {

                type: :integer

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

          'withdraw' => {

            'status' => 'STRING',

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'value' => 'INTEGER',

            'aprroved' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'email' => 'STRING'

            },

            'aprroved_id' => 'INTEGER',

            'payment_method' => {

              'user_id' => 'INTEGER',

              'primary' => 'BOOLEAN',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'payment_method' => 'STRING'

            },

            'payment_method_id' => 'INTEGER'

          },

          'error_object' => {}

        }

        let(:resource) { build(:withdrawal) }

        let(:params) { { withdrawals: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/withdrawals' do
    get 'List withdrawals' do
      tags 'withdrawals'
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

          withdrawals: {
            type: :object,
            properties: {

              status: {

                type: 'string',
                enum: %w[inprogress ready done]

              },

              value: {

                type: :integer

              },

              aprroved_id: {

                type: :integer

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

          'withdraws' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:withdrawal) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
