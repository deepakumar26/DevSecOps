resource "aws_instance" "instance" {
  ami = data.aws_ami.ami.image_id
  instance_type = "t3.small"
  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = "${var.component}-${var.env}"
  }
}