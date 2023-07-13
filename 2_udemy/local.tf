resource "local_file" "myfile" {
  filename = var.filename
  content = "Hello Terraform"
}