require 'swagger_helper'

RSpec.describe 'Admin', type: :request do
  # jitera-hook-for-rswag-example

  path '/api/admins/{id}' do
    put 'Update  admins' do
      tags 'admins'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          admins: {
            type: :object,
            properties: {

              name: {

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

          'admin' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'name' => 'STRING',

            'aproved_products' => 'ARRAY',

            'email' => 'STRING',

            'aprroved_withdrawals' => 'ARRAY',

            'created_categories' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { create(:admin) }

        let(:params) { { admins: resource.attributes.to_hash } }

        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
  path '/api/admins/{id}' do
    get 'Show admins' do
      tags 'admins'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'admin' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'name' => 'STRING',

            'aproved_products' => 'ARRAY',

            'email' => 'STRING',

            'aprroved_withdrawals' => 'ARRAY',

            'created_categories' => 'ARRAY'

          },

          'message' => {}

        }

        let(:resource) { create(:admin) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/admins' do
    post 'Create admins' do
      tags 'admins'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          admins: {
            type: :object,
            properties: {

              name: {

                type: :string

              },

              email: {

                type: :string

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'admin' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'name' => 'STRING',

            'aproved_products' => 'ARRAY',

            'email' => 'STRING',

            'aprroved_withdrawals' => 'ARRAY',

            'created_categories' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { build(:admin) }

        let(:params) { { admins: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/admins' do
    get 'List admins' do
      tags 'admins'
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

          admins: {
            type: :object,
            properties: {

              name: {

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

          'admins' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:admin) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
