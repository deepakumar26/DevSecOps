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
      frontend = 80
    }
    lb = {
      port        = 80
      lb_internal = false
    }
    asg = {
      min_size = 2
      max_size = 3
    }
  }

  auth-service = {
    instance_type = "t3.small"
    ports = {
      auth-service = 8081
    }
    lb = {
      port        = 8081
      lb_internal = true
    }
    asg = {
      min_size = 2
      max_size = 3
    }
  }

  portfolio-service = {
    instance_type = "t3.small"
    ports = {
      portfolio-service = 8080
    }
    lb = {
      port        = 8080
      lb_internal = true
    }
    asg = {
      min_size = 2
      max_size = 3
    }
  }

  analytics-service = {
    instance_type = "t3.small"
    ports = {
      analytics-service = 8000
    }
    lb = {
      port        = 8000
      lb_internal = true
    }
    asg = {
      min_size = 2
      max_size = 3
    }
  }

}