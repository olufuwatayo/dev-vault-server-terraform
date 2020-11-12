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
# cat <<EOF > vault.service
# #!/bin/bash
# /etc/systemd/system/vault.service
# [Unit]
# Description=Vault dev server

# [Service]
# ExecStart=~/vault server -dev -dev-listen-address=127.0.0.1:8200 
# EOF

# vault login
# vault auth enable userpass
# vault write auth/userpass/users/lol policies=default password=lol

# # vault server -dev > /dev/null 2>&1
# <<'EOT'

# echo "test 3"

# # vault policy write read-write-tp ./policy.hcl
# # vault write auth/userpass/users/mitchellh \
# #     password=foo \
# #     policies=read-write-tp

# # vault login -method=userpass username=lol

# vault login -method=userpass username=lol
# lol
# EOT
# vault login -method=userpass username=lol - <<'EOF'
# lol
# EOF
##Login via curl to get the token | Pipe the raw output to JQ | JQ get the ttoken and pass it to vault as a login with -

# Pipe to JQ

# # curl \
# #     --request POST \
# #     --data '{"password": "foo"}' \
# #     http://10.10.218.10:8200/v1/auth/userpass/login/mitchellh

# vault kv put secret/creds passcode=my-long-passcode
# echo "test 5"
# vault kv get -field=passcode secret/creds
# curl -O https://releases.hashicorp.com/vault/0.10.4/vault_0.10.4_linux_amd64.zip


# # screen -d -m vault server -dev -dev-root-token-id='unsecured_token'

# nohup vault server -dev --dev-root-token-id='unsecured_token' dev-listen-address='http://127.0.0.1:8600'&

# -dev-root-token-id='unsecured_token' dev-listen-address='http://127.0.0.1:8200'
# vault login - <<'EOF'
# unsecured_token
# EOF

# curl \
#     -H "X-Vault-Token: unsecured_token" \
#     -X GET \
#     http://127.0.0.1:8200/v1/secret/foo


# curl \
#     --header "X-Vault-Token: unsecured_token" \
#     --request POST \
#     --data @payload.json \
#     http://127.0.0.1:8200/v1/auth/userpass/users/mitchellh


# curl \
#     --header "X-Vault-Token: ..." \
#     --request POST \
#     --data @payload.json \
#     http://127.0.0.1:8200/v1/auth/userpass/users/mitchellh/policies




# curl \
#     --header "X-Vault-Token: unsecured_token" \
#     --request POST \
#     --data @payload.json \
#     http://127.0.0.1:8200/v1/sys/auth/my-auth