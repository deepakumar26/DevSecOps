resource "aws_instance" "instance" {
  for_each = var.components
  ami = "ami-0220d79f3f480ecf5"
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0a742308ff52d8d26"]

  tags = {
    Name = each.key
  }
}

resource "aws_route53_record" "frontend" {
  for_each = var.components
  zone_id = "Z05869702LYKRV86YR4W4"
  name    = "${each.key}-dev"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance[each.key].private_ip]
}

variable "components" {
  default = {
    analytics-service = ""
    portfolio-service = ""
    frontend = ""
    postgresql = ""
    auth-service = ""
  }
}