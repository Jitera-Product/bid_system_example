require 'swagger_helper'

RSpec.describe 'Listing', type: :request do
  # jitera-hook-for-rswag-example

  path '/api/listings/{id}' do
    put 'Update  listings' do
      tags 'listings'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          listings: {
            type: :object,
            properties: {

              description: {

                type: :text

              }

            }
          }

        }
      }
      response '200', 'update' do
        examples 'application/json' => {

          'listing' => {

            'description' => 'TEXT',

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'listing_bid_items' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { create(:listing) }

        let(:params) { { listings: resource.attributes.to_hash } }

        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
  path '/api/listings/{id}' do
    get 'Show listings' do
      tags 'listings'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'listing' => {

            'description' => 'TEXT',

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'listing_bid_items' => 'ARRAY'

          },

          'message' => {}

        }

        let(:resource) { create(:listing) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/listings' do
    post 'Create listings' do
      tags 'listings'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          listings: {
            type: :object,
            properties: {

              description: {

                type: :text

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'listing' => {

            'description' => 'TEXT',

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'listing_bid_items' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { build(:listing) }

        let(:params) { { listings: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/listings' do
    get 'List listings' do
      tags 'listings'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :url, schema: {
        type: :object,
        properties: {

          listings: {
            type: :object,
            properties: {

              description: {

                type: :text

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

          'listings' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:listing) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
