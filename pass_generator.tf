resource "random_password" "user1_vault_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
resource "random_password" "vault_token" {
  length           = 16
  special          = true
  override_special = "_%@"
}
resource "random_pet" "user1_vault_user_name" {
}