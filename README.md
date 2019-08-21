# Sovrin Service for OwnYourData Notary

This service manages references to documents in the [OwnYourData Notary Service](https://notary.ownyourdata.eu) by creating Decentralized Identifiers ([DID](https://w3c-ccg.github.io/did-spec/)s) in the [Sovrin Blockchain](https://sovrin.org).  

## Usage

Get the Docker image: https://cloud.docker.com/u/oydeu/repository/docker/oydeu/srv-sovrin

### Prerequisites
The following inputs must be available: 
* DID registered as TRUST ANCHOR in the Sovrin blockchain  
* wallet that incudes this DID
* link to genesis record of the blockchain
    * Sovrin Live Net: https://github.com/sovrin-foundation/sovrin/blob/stable/sovrin/pool_transactions_live_genesis
    * Sovrin Test Net: https://github.com/sovrin-foundation/sovrin/blob/stable/sovrin/pool_transactions_sandbox_genesis  
      you can register a DID as Trust Anchor in the Sovrin Test Net here: https://s3.us-east-2.amazonaws.com/evernym-cs/sovrin-STNnetwork/www/trust-anchor.html
* `indy-cli` to manage DID and wallet - available here: https://github.com/hyperledger/indy-sdk/tree/master/cli

Compile the inputs from above into a JSON:  
1. in `indy-cli` export the wallet with the DID to a file and note wallet-key and export-key  
    ```
    indy> wallet open my-wallet key=wallet-key
    indy> wallet export export_path=/path/to/wallet export=export-key
    ```
2. base64 encode the exported wallet
    ```
    $ base64 -w0 /path/to/wallet
    ```
3. generate JSON with the following elements:
    ```
    {  
        "master_did":"DID string",
        "genesis_file":"link to genesis record of the blockchain",
        "wallet_key":"wallet-key from wallet export",
        "export_key":"export-key from wallet export",
        "wallet":"base64 encoded wallet"
    }
    ```

### Start the service
```
$ docker run -d -i -p 3000:3000 oydeu/srv-sovrin /bin/init.sh "$(< /path/to/JSON_from_above)"
```

## API Description  
The API exposed by the Docker container is described here: https://api-docs.ownyourdata.eu/notary-sovrin/  

Examples:  
* request a new DID: `curl http://localhost:3000/api/did/new`  
    response: `{"did":"3V7SK7DrUdKYp1A4QAMNHy","seed":"e0015c5ba2894c7091ae8d1a0d14ca5c","verkey":"~FC9tYLSoDCnGwXSALCZKJc"}`  
* write DID to blockchain: `curl -d did=3V7SK7DrUdKYp1A4QAMNHy -d verkey=~FC9tYLSoDCnGwXSALCZKJc -d seed=e0015c5ba2894c7091ae8d1a0d14ca5c -d hash=476911022fc90f12f23052ddc863fd2a3ad3e9f3123b986dd1fded867cd3ae27 -X POST http://localhost:3000/api/did/create`  
    response: `{"wallet-key":"9bec3b1cf9a0","export-key":"14f34009253d","wallet":"VA...ha"}`
    
### Importing the wallet  
To use the new DID in the provided wallet perform the following steps:
1. create wallet file  
    ```
    $ echo -n "base64 encoded wallet" | base64 -d > new_wallet
    ```
2. import wallet in `indy-cli`
   ```
   indy> pool connect sovrin
   indy> wallet import new_wallet_name key=wallet-key export_path=/path/to/new_wallet export_key=export-key
   indy> wallet open new_wallet key=wallet-key
   indy> did use new-did
   indy> did rotate-key  # make sure to update keys after getting a DID from a public service
   ```

## Improve the Sovrin Service for OwnYourData Notary
Please report bugs and suggestions for new features using the [GitHub Issue-Tracker](https://github.com/OwnYourData/srv-sovrin/issues) and follow the [Contributor Guidelines](https://github.com/twbs/ratchet/blob/master/CONTRIBUTING.md).

If you want to contribute, please follow these steps:

1. Fork it!
2. Create a feature branch: `git checkout -b my-new-feature`
3. Commit changes: `git commit -am 'Add some feature'`
4. Push into branch: `git push origin my-new-feature`
5. Send a Pull Request

&nbsp;    

## Lizenz

[MIT License 2018 - OwnYourData.eu](https://raw.githubusercontent.com/OwnYourData/srv-sovrin/master/LICENSE)
