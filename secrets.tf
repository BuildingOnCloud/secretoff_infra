# Secret 1
resource "aws_secretsmanager_secret" "secret1" {
  name = "APP_PORT"
}
resource "aws_secretsmanager_secret_version" "secret1" {
  secret_id     = aws_secretsmanager_secret.secret1.id
  secret_string = "8080"
}

# Secret 2
resource "aws_secretsmanager_secret" "secret2" {
  name = "API_KEY"
}
resource "aws_secretsmanager_secret_version" "secret2" {
  secret_id     = aws_secretsmanager_secret.secret2.id
  secret_string = "Secret Off"
}
