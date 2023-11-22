require 'swagger_helper'

RSpec.describe 'BidItem', type: :request do
  # jitera-hook-for-rswag-example

  path '/api/bid_items/{id}' do
    put 'Update  bid_items' do
      tags 'bid_items'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          bid_items: {
            type: :object,
            properties: {

              user_id: {

                type: :integer

              },

              product_id: {

                type: :integer

              },

              base_price: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[draft ready done]

              },

              name: {

                type: :string

              },

              expiration_time: {

                type: :datetime

              }

            }
          }

        }
      }
      response '200', 'update' do
        examples 'application/json' => {

          'bid_item' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'base_price' => 'INTEGER',

            'status' => 'STRING',

            'user_id' => 'INTEGER',

            'product' => {

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'base_price' => 'INTEGER',

              'description' => 'TEXT',

              'image' => 'FILE',

              'id' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'product_id' => 'INTEGER',

            'name' => 'STRING',

            'expiration_time' => 'DATETIME',

            'item_bids' => 'ARRAY',

            'listing_bid_items' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { create(:bid_item) }

        let(:params) { { bid_items: resource.attributes.to_hash } }

        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
  path '/api/bid_items/{id}' do
    get 'Show bid_items' do
      tags 'bid_items'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'bid_item' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'base_price' => 'INTEGER',

            'status' => 'STRING',

            'user_id' => 'INTEGER',

            'product' => {

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'base_price' => 'INTEGER',

              'description' => 'TEXT',

              'image' => 'FILE',

              'id' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'product_id' => 'INTEGER',

            'name' => 'STRING',

            'expiration_time' => 'DATETIME',

            'item_bids' => 'ARRAY',

            'listing_bid_items' => 'ARRAY'

          },

          'message' => {}

        }

        let(:resource) { create(:bid_item) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/bid_items' do
    post 'Create bid_items' do
      tags 'bid_items'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          bid_items: {
            type: :object,
            properties: {

              user_id: {

                type: :integer

              },

              product_id: {

                type: :integer

              },

              base_price: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[draft ready done]

              },

              name: {

                type: :string

              },

              expiration_time: {

                type: :datetime

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'bid_item' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'base_price' => 'INTEGER',

            'status' => 'STRING',

            'user_id' => 'INTEGER',

            'product' => {

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'base_price' => 'INTEGER',

              'description' => 'TEXT',

              'image' => 'FILE',

              'id' => 'INTEGER',

              'user_id' => 'INTEGER'

            },

            'product_id' => 'INTEGER',

            'name' => 'STRING',

            'expiration_time' => 'DATETIME',

            'item_bids' => 'ARRAY',

            'listing_bid_items' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { build(:bid_item) }

        let(:params) { { bid_items: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/bid_items' do
    get 'List bid_items' do
      tags 'bid_items'
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

          bid_items: {
            type: :object,
            properties: {

              user_id: {

                type: :integer

              },

              product_id: {

                type: :integer

              },

              base_price: {

                type: :integer

              },

              status: {

                type: 'string',
                enum: %w[draft ready done]

              },

              name: {

                type: :string

              },

              expiration_time: {

                type: :datetime

              }

            }
          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'bid_items' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:bid_item) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
