#!/bin/bash
# Use the root Vault token to configure Vault with a policy to read/write to some 
# secret path and create a user associated with this policy. 
# ○Log into Vault as the new user, write some value to the path, then read it from 
# the path. 

exec &> logfile.txt
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install vault -y
sudo apt-get install jq -y # would need this because I need to sort the json response
cat > samson_policy.hcl <<'EOF'
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF
# -dev-root-token-id='unsecured_token' dev-listen-address='http://127.0.0.1:8200'
# echo "test 0"
# export VAULT_ADDR='http://127.0.0.1:8200'
screen -d -m vault server -dev -dev-root-token-id='unsecured_token'
echo "vault started in screen "
sleep 10
#Needed to sleep because for some weird reasons my env vars are not set | I need to find out why
export VAULT_ADDR='http://127.0.0.1:8200'
echo "we just set vault endpoint url"
# export VAULT_TOKEN='unsecured_token'
echo "we login with insecure token"
vault login - <<< unsecured_token
vault auth enable userpass
vault policy write samson_policy ./samson_policy.hcl
vault write auth/userpass/users/samson policies=samson_policy password=dumbpassword
curl --request POST --data '{"password": "dumbpassword"}' http://127.0.0.1:8200/v1/auth/userpass/login/samson | jq -r .auth.client_token | vault login -
vault kv put secret/hello foo=world
vault kv get secret/hello
