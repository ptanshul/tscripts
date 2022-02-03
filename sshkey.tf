resource "tls_private_key" "bhstlskey" {
  algorithm   = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" {

	value = tls_private_key.bhstlskey.private_key_pem
	sensitive = true 
}
