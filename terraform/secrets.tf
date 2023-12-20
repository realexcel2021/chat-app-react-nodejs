# database random password
resource "random_password" "master" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

# database password secret
resource "aws_secretsmanager_secret" "password" {
  name = "snappy-db-password-wiwj"
  recovery_window_in_days = 7
}

# add the secret value to the manager
resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = random_password.master.result
}

# database endpoint secret
resource "aws_secretsmanager_secret" "db-endpoint" {
  name       = "snappy-db-endpoint-wij"
  recovery_window_in_days = 7
  depends_on = [aws_docdb_cluster.docdb]
}

# add the endpoint value
resource "aws_secretsmanager_secret_version" "db-endpoint-val" {
  secret_id     = aws_secretsmanager_secret.db-endpoint.id
  secret_string = aws_docdb_cluster.docdb.endpoint
}