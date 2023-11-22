require 'swagger_helper'

RSpec.describe 'Shipping', type: :request do
  # jitera-hook-for-rswag-example

  path '/api/shippings/{id}' do
    put 'Update  shippings' do
      tags 'shippings'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          shippings: {
            type: :object,
            properties: {

              shiping_address: {

                type: :string

              },

              post_code: {

                type: :integer

              },

              phone_number: {

                type: :string

              },

              bid_id: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[new queue inprogress done]

              },

              full_name: {

                type: :string

              },

              email: {

                type: :string

              }

            }
          }

        }
      }
      response '200', 'update' do
        examples 'application/json' => {

          'shipping' => {

            'shiping_address' => 'STRING',

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'full_name' => 'STRING',

            'status' => 'STRING',

            'post_code' => 'INTEGER',

            'phone_number' => 'STRING',

            'email' => 'STRING',

            'bid' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'status' => 'STRING',

              'price' => 'INTEGER',

              'item_id' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'bid_id' => 'INTEGER'

          },

          'error_object' => {}

        }

        let(:resource) { create(:shipping) }

        let(:params) { { shippings: resource.attributes.to_hash } }

        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
  path '/api/shippings/{id}' do
    get 'Show shippings' do
      tags 'shippings'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'shipping' => {

            'shiping_address' => 'STRING',

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'full_name' => 'STRING',

            'status' => 'STRING',

            'post_code' => 'INTEGER',

            'phone_number' => 'STRING',

            'email' => 'STRING',

            'bid' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'status' => 'STRING',

              'price' => 'INTEGER',

              'item_id' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'bid_id' => 'INTEGER'

          },

          'message' => {}

        }

        let(:resource) { create(:shipping) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/shippings' do
    get 'List shippings' do
      tags 'shippings'
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

          shippings: {
            type: :object,
            properties: {

              shiping_address: {

                type: :string

              },

              post_code: {

                type: :integer

              },

              phone_number: {

                type: :string

              },

              bid_id: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[new queue inprogress done]

              },

              full_name: {

                type: :string

              },

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

          'shippings' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:shipping) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
