module Api
    module V1
        class InfosController < ApiController
            # respond only to JSON requests
            respond_to :json
            respond_to :html, only: []
            respond_to :xml, only: []

            def create
            	gen_txn_file = File.basename(URI.parse(params["genesis_file"].to_s).path).to_s
            	# store data
				Info.destroy_all
				Info.new(wallet_key: params["wallet_key"].to_s,
						 export_key: params["export_key"].to_s,
						 did: params["master_did"],
						 genesis_file: gen_txn_file).save

				# create pool from genesis_file
				indy_cmd =  "pool create sovrin gen_txn_file=" + gen_txn_file + "\n"
				indy_cmd += "wallet import local-wallet key=" + params["wallet_key"].to_s
				indy_cmd +=       " export_path=/usr/src/app/wallet"
				indy_cmd +=       " export_key=" + params["export_key"].to_s + "\n"
				cmd = ' printf "' + indy_cmd + '" | indy-cli'
				system "bash", "-c", cmd

                render plain: "", 
                       status: 200
            end

            def show
            	render json: Info.first.to_json,
            		   status: 200
           	end
        end
    end
end
