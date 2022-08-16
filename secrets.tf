# Secret 1
resource "aws_secretsmanager_secret" "secretoff_secret1" {
  name = "APP_PORT"
}
 
resource "aws_secretsmanager_secret_version" "secretversion1" {
  secret_id     = aws_secretsmanager_secret.secretoff_secret1.id
  secret_string = "8080"
}

# Secret 2
resource "aws_secretsmanager_secret" "secretoff_secret2" {
  name = "API_KEY"
}
 
resource "aws_secretsmanager_secret_version" "secretversion2" {
  secret_id     = aws_secretsmanager_secret.secretoff_secret2.id
  secret_string = "Secret Off"
}

resource "aws_secretsmanager_secret" "example" {
  name = "example"
}
resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = "example-string-to-protect"
}
