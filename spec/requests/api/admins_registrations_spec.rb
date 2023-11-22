require 'swagger_helper'

RSpec.describe 'Admin', type: :request do
  # jitera-hook-for-rswag-example
  path '/api/admins_registrations' do
    post 'Sign up by email' do
      tags 'Email Login - admins'
      consumes 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          admin: {
            type: :object,
            properties: {

              password: {

                type: :string

              },

              password_confirmation: {

                type: :string

              },

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

      response '200', 'auth_registration' do
        examples 'application/json' => {

          'id' => 'STRING'

        }
        let(:resource) { build(:admin) }

        let(:params) { { admin: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eql(200)
        end
      end

      response '422', 'Cannot register' do
        examples 'application/json' => {
          error_message: I18n.t('email_login.registrations.failed_to_sign_up')
        }
        let(:params) { {} }
        run_test! do |response|
          expect(response.status).to eql(422)
        end
      end
    end
  end
end
