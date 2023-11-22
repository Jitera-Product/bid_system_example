require 'swagger_helper'

RSpec.describe 'Product', type: :request do
  # jitera-hook-for-rswag-example

  path '/api/products/{id}' do
    put 'Update  products' do
      tags 'products'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          products: {
            type: :object,
            properties: {

              name: {

                type: :string

              },

              price: {

                type: :integer

              },

              description: {

                type: :text

              },

              image: {

                type: :file

              },

              user_id: {

                type: :integer

              },

              stock: {

                type: :integer

              },

              aproved_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'update' do
        examples 'application/json' => {

          'product' => {

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'id' => 'INTEGER',

            'name' => 'STRING',

            'price' => 'INTEGER',

            'description' => 'TEXT',

            'image' => 'FILE',

            'user_id' => 'INTEGER',

            'bid_items' => 'ARRAY',

            'stock' => 'INTEGER',

            'aproved' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING'

            },

            'aproved_id' => 'INTEGER',

            'product_categories' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { create(:product) }

        let(:params) { { products: resource.attributes.to_hash } }

        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
  path '/api/products/{id}' do
    get 'Show products' do
      tags 'products'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'product' => {

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'id' => 'INTEGER',

            'name' => 'STRING',

            'price' => 'INTEGER',

            'description' => 'TEXT',

            'image' => 'FILE',

            'user_id' => 'INTEGER',

            'bid_items' => 'ARRAY',

            'stock' => 'INTEGER',

            'aproved' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING'

            },

            'aproved_id' => 'INTEGER',

            'product_categories' => 'ARRAY'

          },

          'message' => {}

        }

        let(:resource) { create(:product) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/products' do
    post 'Create products' do
      tags 'products'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          products: {
            type: :object,
            properties: {

              name: {

                type: :string

              },

              price: {

                type: :integer

              },

              description: {

                type: :text

              },

              image: {

                type: :file

              },

              user_id: {

                type: :integer

              },

              stock: {

                type: :integer

              },

              aproved_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'product' => {

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'id' => 'INTEGER',

            'name' => 'STRING',

            'price' => 'INTEGER',

            'description' => 'TEXT',

            'image' => 'FILE',

            'user_id' => 'INTEGER',

            'bid_items' => 'ARRAY',

            'stock' => 'INTEGER',

            'aproved' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'name' => 'STRING'

            },

            'aproved_id' => 'INTEGER',

            'product_categories' => 'ARRAY'

          },

          'error_object' => {}

        }

        let(:resource) { build(:product) }

        let(:params) { { products: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/products' do
    get 'List products' do
      tags 'products'
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

          products: {
            type: :object,
            properties: {

              name: {

                type: :string

              },

              description: {

                type: :text

              },

              user_id: {

                type: :integer

              },

              stock: {

                type: :integer

              },

              price: {

                type: :integer

              },

              aproved_id: {

                type: :integer

              }

            }
          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'products' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:product) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
