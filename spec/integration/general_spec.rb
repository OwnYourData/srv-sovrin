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
	path '/api/did/create' do
		post "write DID" do
			tags 'General'
			produces 'application/json'
			consumes 'application/json'
			parameter name: :input, in: :body
			response '200', 'success' do
				let(:input) { { "did":"123", "seed": "456", "verkey": "789", "hash": "0ab" } }
				schema type: :object,
					properties: {
						"wallet-key": { type: :string },
						"export-key": { type: :string },
						wallet: { type: :string }
					},
				required: [ 'wallet-key', 'export-key', 'wallet' ]
				run_test!
			end
		end
	end
end
