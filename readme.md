# Vault dev server

This script sets up a Vault dev server in aws and creates a user with access to read and write secrets to it
## Installation

Ensure you have terraform  and AWS CLI and setup
```bash
brew install terraform
brew install awscli
aws configure
```
Setup aws cli ssm using this https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-macos
## Usage

```python
terraform init
terraform plan
terraform apply 

aws ssm start-session \
    --target instance_id 
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)