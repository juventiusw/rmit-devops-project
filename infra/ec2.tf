resource "aws_key_pair" "deployer" {
  key_name   = "rmit-assignment-2-key"
  public_key = file("/tmp/keys/ec2-key.pub")
}
