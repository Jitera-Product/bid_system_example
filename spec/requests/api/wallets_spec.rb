require 'swagger_helper'

RSpec.describe 'Wallet', type: :request do
  # jitera-hook-for-rswag-example
  path '/api/wallets/{id}' do
    get 'Show wallets' do
      tags 'wallets'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'wallet' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'balance' => 'INTEGER',

            'user' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME',

              'email' => 'STRING'

            },

            'user_id' => 'INTEGER',

            'transactions' => 'ARRAY',

            'deposits' => 'ARRAY',

            'locked' => 'BOOLEAN'

          },

          'message' => {}

        }

        let(:resource) { create(:wallet) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
