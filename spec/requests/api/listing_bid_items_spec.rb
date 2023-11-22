require 'swagger_helper'

RSpec.describe 'ListingBidItem', type: :request do
  # jitera-hook-for-rswag-example
  path '/api/listing_bid_items/{id}' do
    delete 'Destroy listing_bid_items' do
      tags 'listing_bid_items'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'delete' do
        examples 'application/json' => {

          'message' => {}

        }

        let(:resource) { create(:listing_bid_item) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/listing_bid_items/{id}' do
    get 'Show listing_bid_items' do
      tags 'listing_bid_items'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'listing_bid_item' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'listing' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'description' => 'TEXT'

            },

            'listing_id' => 'INTEGER',

            'bid_item' => {

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

            'bid_item_id' => 'INTEGER'

          },

          'message' => {}

        }

        let(:resource) { create(:listing_bid_item) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/listing_bid_items' do
    post 'Create listing_bid_items' do
      tags 'listing_bid_items'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          listing_bid_items: {
            type: :object,
            properties: {

              listing_id: {

                type: :integer

              },

              bid_item_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'listing_bid_item' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'listing' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'description' => 'TEXT'

            },

            'listing_id' => 'INTEGER',

            'bid_item' => {

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

            'bid_item_id' => 'INTEGER'

          },

          'error_object' => {}

        }

        let(:resource) { build(:listing_bid_item) }

        let(:params) { { listing_bid_items: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/listing_bid_items' do
    get 'List listing_bid_items' do
      tags 'listing_bid_items'
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

          listing_bid_items: {
            type: :object,
            properties: {

              listing_id: {

                type: :integer

              },

              bid_item_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'listing_bid_items' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:listing_bid_item) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
