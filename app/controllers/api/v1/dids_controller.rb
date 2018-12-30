module Api
    module V1
        class DidsController < ApiController
            # respond only to JSON requests
            respond_to :json
            respond_to :html, only: []
            respond_to :xml, only: []

            require 'securerandom'
            require 'base64'

            def new
                @info = Info.first
                seed = SecureRandom.hex(16)

				# create pool from genesis_file
				indy_cmd =  "pool connect sovrin\n"
				indy_cmd += "wallet open local-wallet key=" + @info["wallet_key"].to_s + "\n"
                indy_cmd += "did use " + @info["did"].to_s + "\n"
                indy_cmd += "did new seed=" + seed.to_s + " metadata=oyd_notary\n"
				cmd = 'printf "' + indy_cmd + '" | indy-cli'
                output = `#{cmd}`
                new_did = ""
                verkey = ""
                output.each_line do |line|
                    retVal = line.scan(/Did \"(.*)\" has been created with \"(.*)\" verkey/)
                    if retVal.length > 0
                        new_did = retVal.first[0]
                        verkey = retVal.first[1]
                    end
                end

                if new_did.to_s.length == 0 or verkey.to_s.length == 0
                    render json: { "error": "failure on creating DID" }.to_json,
                           status: 500
                else
                    render json: { "did": new_did,
                                   "seed": seed,
                                   "verkey": verkey }.to_json, 
                           status: 200
                end
            end

            def create
                did = params[:did].to_s
                verkey = params[:verkey].to_s
                seed = params[:seed].to_s
                new_hash = params[:hash].to_s

                @info = Info.first
                hex12a = SecureRandom.hex(6)
                hex12b = SecureRandom.hex(6)
                wallet_uniq = "wallet_" + SecureRandom.base64(6)
                wallet_path = "/usr/src/app/" + wallet_uniq

                indy_cmd =  "pool connect sovrin\n"
                indy_cmd += "wallet open local-wallet key=" + @info["wallet_key"].to_s + "\n"
                indy_cmd += "did use " + @info["did"].to_s + "\n"
                indy_cmd += "ledger nym did=" + did + " verkey=" + verkey + "\n"
                indy_cmd += "wallet create " + wallet_uniq + " key=" + hex12a + "\n"
                indy_cmd += "wallet open " + wallet_uniq + " key=" + hex12a + "\n"
                indy_cmd += "did new did=" + did + " seed=" + seed + " metadata=oyd_notary\n"
                indy_cmd += "did use " + did + "\n"
                indy_cmd += 'ledger attrib did=' + did + ' raw={\"endpoint\":{\"custom\":\"https://notary.ownyourdata.eu/?hash=' + new_hash + '\"}}' + "\n"
                indy_cmd += "wallet export export_path=" + wallet_path + " export_key=" + hex12b + "\n"
                indy_cmd += "wallet close\n"
                indy_cmd += "wallet delete " + wallet_uniq + " key=" + hex12a + "\n"
                cmd = 'printf "' + indy_cmd + '" | indy-cli'
                system "bash", "-c", cmd

                content = File.read(wallet_path) rescue ""
                File.delete(wallet_path) if File.exist?(wallet_path)

                if content.to_s.length == 0
                    render json: { "error": "failure on writing DID" }.to_json,
                           status: 500
                else
                    render json: { "wallet-key": hex12a,
                                   "export-key": hex12b,
                                   "wallet": Base64.strict_encode64(content).to_s }.to_json, 
                           status: 200
                end
            end
        end
    end
end
