resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "public_key" {
  value = tls_private_key.tls.public_key_openssh
}

output "private_key" {
  value = tls_private_key.tls.private_key_pem
  sensitive = true
}