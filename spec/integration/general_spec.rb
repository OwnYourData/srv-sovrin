# spec/integration/general_spec.rb
# rake rswag:specs:swaggerize

require 'swagger_helper'

describe 'Sovrin Service API' do
	path '/api/did/new' do
		get 'request new DID' do
			tags 'General'
			produces 'application/json'
			response '200', 'success' do
				schema type: :object,
					properties: {
						did: { type: :string },
						seed: { type: :string },
						verkey: { type: :string }
					},
				required: [ 'did', 'seed', 'verkey' ]
				run_test!
			end
		end
	end
end
