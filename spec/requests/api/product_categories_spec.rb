require 'swagger_helper'

RSpec.describe 'ProductCategory', type: :request do
  # jitera-hook-for-rswag-example

  path '/api/product_categories/{id}' do
    put 'Update  product_categories' do
      tags 'product_categories'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          product_categories: {
            type: :object,
            properties: {

              category_id: {

                type: :integer

              },

              product_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'update' do
        examples 'application/json' => {

          'product_category' => {

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'id' => 'INTEGER',

            'category' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'created_id' => 'INTEGER'

            },

            'category_id' => 'INTEGER',

            'product' => {

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'price' => 'INTEGER',

              'description' => 'TEXT',

              'image' => 'FILE',

              'stock' => 'INTEGER',

              'id' => 'INTEGER',

              'user_id' => 'INTEGER',

              'aproved_id' => 'INTEGER'

            },

            'product_id' => 'INTEGER'

          },

          'error_object' => {}

        }

        let(:resource) { create(:product_category) }

        let(:params) { { product_categories: resource.attributes.to_hash } }

        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
  path '/api/product_categories/{id}' do
    get 'Show product_categories' do
      tags 'product_categories'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'product_category' => {

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'id' => 'INTEGER',

            'category' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'created_id' => 'INTEGER'

            },

            'category_id' => 'INTEGER',

            'product' => {

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'price' => 'INTEGER',

              'description' => 'TEXT',

              'image' => 'FILE',

              'stock' => 'INTEGER',

              'id' => 'INTEGER',

              'user_id' => 'INTEGER',

              'aproved_id' => 'INTEGER'

            },

            'product_id' => 'INTEGER'

          },

          'message' => {}

        }

        let(:resource) { create(:product_category) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/product_categories' do
    post 'Create product_categories' do
      tags 'product_categories'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          product_categories: {
            type: :object,
            properties: {

              category_id: {

                type: :integer

              },

              product_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'product_category' => {

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'id' => 'INTEGER',

            'category' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'created_id' => 'INTEGER'

            },

            'category_id' => 'INTEGER',

            'product' => {

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'price' => 'INTEGER',

              'description' => 'TEXT',

              'image' => 'FILE',

              'stock' => 'INTEGER',

              'id' => 'INTEGER',

              'user_id' => 'INTEGER',

              'aproved_id' => 'INTEGER'

            },

            'product_id' => 'INTEGER'

          },

          'error_object' => {}

        }

        let(:resource) { build(:product_category) }

        let(:params) { { product_categories: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/product_categories' do
    get 'List product_categories' do
      tags 'product_categories'
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

          product_categories: {
            type: :object,
            properties: {

              category_id: {

                type: :integer

              },

              product_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'product_categories' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:product_category) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
