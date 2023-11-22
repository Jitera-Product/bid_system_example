require 'swagger_helper'

RSpec.describe 'Category', type: :request do
  # jitera-hook-for-rswag-example

  path '/api/categories/{id}' do
    put 'Update  categories' do
      tags 'categories'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          categories: {
            type: :object,
            properties: {

              name: {

                type: :string

              },

              created_id: {

                type: :integer

              },

              disabled: {

                type: :boolean

              }

            }
          }

        }
      }
      response '200', 'update' do
        examples 'application/json' => {

          'category' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'name' => 'STRING',

            'created' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'email' => 'STRING'

            },

            'created_id' => 'INTEGER',

            'product_categories' => 'ARRAY',

            'disabled' => 'BOOLEAN'

          },

          'error_object' => {}

        }

        let(:resource) { create(:category) }

        let(:params) { { categories: resource.attributes.to_hash } }

        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
  path '/api/categories/{id}' do
    get 'Show categories' do
      tags 'categories'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'category' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'name' => 'STRING',

            'created' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'email' => 'STRING'

            },

            'created_id' => 'INTEGER',

            'product_categories' => 'ARRAY',

            'disabled' => 'BOOLEAN'

          },

          'message' => {}

        }

        let(:resource) { create(:category) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/categories' do
    post 'Create categories' do
      tags 'categories'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          categories: {
            type: :object,
            properties: {

              name: {

                type: :string

              },

              created_id: {

                type: :integer

              },

              disabled: {

                type: :boolean

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'category' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'name' => 'STRING',

            'created' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING',

              'email' => 'STRING'

            },

            'created_id' => 'INTEGER',

            'product_categories' => 'ARRAY',

            'disabled' => 'BOOLEAN'

          },

          'error_object' => {}

        }

        let(:resource) { build(:category) }

        let(:params) { { categories: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/categories' do
    get 'List categories' do
      tags 'categories'
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

          categories: {
            type: :object,
            properties: {

              name: {

                type: :string

              },

              created_id: {

                type: :integer

              },

              disabled: {

                type: :boolean

              }

            }
          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'categories' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:category) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
