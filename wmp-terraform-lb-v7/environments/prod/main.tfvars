dns_domain = "cubicletocharts.cloud."
env        = "prod"
vpc_id     = "vpc-0c4b3099e2796acdb"
subnets    = ["subnet-0c871903f94f5277c", "subnet-02a90961b42650018"]

databases = {
  postgresql = {
    instance_type = "t3.small"
    ports = {
      ssh        = 22
      postgresql = 5432
    }
  }
}

apps = {

  frontend = {
    instance_type = "t3.small"
    ports = {
      ssh      = 22
      frontend = 80
    }
  }

  auth-service = {
    instance_type = "t3.small"
    ports = {
      ssh          = 22
      auth-service = 8081
    }
  }

  portfolio-service = {
    instance_type = "t3.small"
    ports = {
      ssh               = 22
      portfolio-service = 8080
    }
  }

  analytics-service = {
    instance_type = "t3.small"
    ports = {
      ssh               = 22
      analytics-service = 8000
    }
  }

}