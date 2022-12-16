output "public-dns" {
  value = aws_instance.web[*].public_dns
}

output "Public-ip" {
  value = aws_instance.web[*].public_ip
}

resource "local_file" "inventory" {
  filename = "../ansible/inventory.yml"
  content  = <<EOF
all:
  children:
    web:
      hosts:
        "${aws_instance.web[0].public_ip}"
    db:
      hosts:
        "${aws_instance.db[0].public_ip}"
EOF
}

#resource "local_file" "app_env" {
#  filename = "../src/.env"
#  content = <<EOF
#SERVER=mongodb://${aws_instance.db[0].public_ip}:27017
#EOF
#}

resource "local_file" "db_vars" {
  filename = "../ansible/vars/db.yml"
  content  = <<EOF
db_url: ${aws_instance.db[0].public_ip}
EOF
}