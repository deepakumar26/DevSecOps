terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

resource "aws_db_parameter_group" "main" {
  name   = "wmp-${var.env}"
  family = "postgres16"
}

resource "aws_db_subnet_group" "main" {
  name       = "wmp-${var.env}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "wmp-${var.env}"
  }
}

resource "aws_security_group" "main" {
  name = "wmp-rds-${var.env}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wmp-rds-${var.env}"
  }
}

resource "aws_db_instance" "main" {
  identifier             = "wmp-${var.env}"
  allocated_storage      = var.allocated_storage
  db_name                = "default_dummy"
  engine                 = "postgres"
  engine_version         = "16.13"
  instance_class         = "db.t3.micro"
  username               = "wmpuser"
  password               = "WmpUser#1234"
  parameter_group_name   = aws_db_parameter_group.main.name
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]
}

resource "null_resource" "schema_load" {
  depends_on = [
    aws_db_instance.main
  ]

  triggers = {
    database_address = aws_db_instance.main.address
    schema_hash      = filesha256("${path.module}/setup.sql")
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    environment = {
      PGPASSWORD = "WmpUser#1234"
    }

    command = join(" ", [
      "set -e;",
      "echo 'Installing required packages...';",
      "sudo dnf install -y curl dos2unix;",
      "if [ ! -x /usr/pgsql-16/bin/psql ] && ! command -v psql >/dev/null 2>&1; then sudo dnf install -y postgresql16 || sudo dnf install -y postgresql; fi;",
      "PSQL_BIN=$(command -v psql 2>/dev/null || true);",
      "if [ -z \"$PSQL_BIN\" ] && [ -x /usr/pgsql-16/bin/psql ]; then PSQL_BIN=/usr/pgsql-16/bin/psql; fi;",
      "if [ -z \"$PSQL_BIN\" ]; then echo 'ERROR: PostgreSQL psql client not found'; exit 1; fi;",
      "echo \"Using psql: $PSQL_BIN\";",
      "dos2unix '${abspath(path.module)}/setup.sql';",
      "curl -fsSL -o '${abspath(path.module)}/global-bundle.pem' 'https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem';",
      "test -s '${abspath(path.module)}/global-bundle.pem' || { echo 'ERROR: Certificate download failed'; exit 1; };",
      "echo 'Waiting for PostgreSQL database...';",
      "for attempt in $(seq 1 30); do \"$PSQL_BIN\" 'host=${aws_db_instance.main.address} port=5432 dbname=default_dummy user=wmpuser sslmode=verify-full sslrootcert=${abspath(path.module)}/global-bundle.pem' -c 'SELECT 1;' >/dev/null 2>&1 && break; if [ \"$attempt\" -eq 30 ]; then echo 'ERROR: Database connection failed'; exit 1; fi; echo \"Waiting: attempt $attempt/30\"; sleep 10; done;",
      "echo 'Loading database schema...';",
      "\"$PSQL_BIN\" --set=ON_ERROR_STOP=1 'host=${aws_db_instance.main.address} port=5432 dbname=default_dummy user=wmpuser sslmode=verify-full sslrootcert=${abspath(path.module)}/global-bundle.pem' -f '${abspath(path.module)}/setup.sql';",
      "echo 'Database schema loaded successfully';"
    ])
  }
}