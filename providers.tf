provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = {
      Environment = "Development"
      Owner       = "Ops"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
  default_tags {
    tags = {
      Environment = "Development"
      Owner       = "Ops"
    }
  }
}


provider "aws" {
  region = "ap-southeast-2"
  alias  = "prod"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.prod.account_id}:role/Admin"
  }
  default_tags {
    tags = {
      Environment = "Production"
      Owner       = "Ops"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "dev"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dev.account_id}:role/Admin"
  }
  default_tags {
    tags = {
      Environment = "Development"
      Owner       = "Ops"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "logs"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.logs.account_id}:role/Admin"
  }
  default_tags {
    tags = {
      Environment = "Logging"
      Owner       = "Ops"
    }
  }
}

// provider "aws" {
//   region = "ap-southeast-2"
//   alias  = "logs"
//   assume_role {
//     role_arn = "arn:aws:iam::${data.aws_organizations_account.logs.account_id}:role/Admin"
//   }
//   default_tags {
//     tags = {
//       Environment = "Logging"
//       Owner       = "Ops"
//     }
//   }
// }