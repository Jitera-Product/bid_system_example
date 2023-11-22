require 'swagger_helper'

RSpec.describe 'Bid', type: :request do
  # jitera-hook-for-rswag-example

  path '/api/bids/{id}' do
    put 'Update  bids' do
      tags 'bids'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          bids: {
            type: :object,
            properties: {

              price: {

                type: :integer

              },

              item_id: {

                type: :integer

              },

              user_id: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[new paid refund]

              }

            }
          }

        }
      }
      response '200', 'update' do
        examples 'application/json' => {

          'bid' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'price' => 'INTEGER',

            'item' => {

              'product_id' => 'INTEGER',

              'base_price' => 'INTEGER',

              'expiration_time' => 'DATETIME',

              'status' => 'STRING',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'user_id' => 'INTEGER',

              'name' => 'STRING'

            },

            'item_id' => 'INTEGER',

            'user_id' => 'INTEGER',

            'status' => 'STRING',

            'shipping' => {

              'post_code' => 'INTEGER',

              'full_name' => 'STRING',

              'phone_number' => 'STRING',

              'email' => 'STRING',

              'bid_id' => 'INTEGER',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'status' => 'STRING',

              'shiping_address' => 'STRING'

            }

          },

          'error_object' => {}

        }

        let(:resource) { create(:bid) }

        let(:params) { { bids: resource.attributes.to_hash } }

        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
  path '/api/bids/{id}' do
    get 'Show bids' do
      tags 'bids'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'bid' => {

            'price' => 'INTEGER',

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'item' => {

              'product_id' => 'INTEGER',

              'base_price' => 'INTEGER',

              'expiration_time' => 'DATETIME',

              'status' => 'STRING',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'user_id' => 'INTEGER',

              'name' => 'STRING'

            },

            'item_id' => 'INTEGER',

            'user_id' => 'INTEGER',

            'status' => 'STRING',

            'shipping' => {

              'post_code' => 'INTEGER',

              'full_name' => 'STRING',

              'phone_number' => 'STRING',

              'email' => 'STRING',

              'bid_id' => 'INTEGER',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'status' => 'STRING',

              'shiping_address' => 'STRING'

            }

          },

          'message' => {}

        }

        let(:resource) { create(:bid) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/bids' do
    post 'Create bids' do
      tags 'bids'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          bids: {
            type: :object,
            properties: {

              price: {

                type: :integer

              },

              item_id: {

                type: :integer

              },

              user_id: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[new paid refund]

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'bid' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'price' => 'INTEGER',

            'item' => {

              'product_id' => 'INTEGER',

              'base_price' => 'INTEGER',

              'expiration_time' => 'DATETIME',

              'status' => 'STRING',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'user_id' => 'INTEGER',

              'name' => 'STRING'

            },

            'item_id' => 'INTEGER',

            'user_id' => 'INTEGER',

            'status' => 'STRING',

            'shipping' => {

              'post_code' => 'INTEGER',

              'full_name' => 'STRING',

              'phone_number' => 'STRING',

              'email' => 'STRING',

              'bid_id' => 'INTEGER',

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'status' => 'STRING',

              'shiping_address' => 'STRING'

            }

          },

          'error_object' => {}

        }

        let(:resource) { build(:bid) }

        let(:params) { { bids: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/bids' do
    get 'List bids' do
      tags 'bids'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :url, schema: {
        type: :object,
        properties: {

          bids: {
            type: :object,
            properties: {

              price: {

                type: :integer

              },

              item_id: {

                type: :integer

              },

              user_id: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[new paid refund]

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

          'bids' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:bid) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
