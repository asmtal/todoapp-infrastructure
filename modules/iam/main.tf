// Administrators
resource "aws_iam_role" "administrators" {
  name               = "administrators"
  path               = "/users/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "administrators" {
  role       = aws_iam_role.administrators.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "administrators" {
  group = aws_iam_group.administrators.name
  policy_arn = aws_iam_policy.administrators.arn
}

resource "aws_iam_group" "administrators" {
  name = "administrators"
  path = "/users/"
}

// Developers

resource "aws_iam_role" "developers" {
  name               = "developers"
  path               = "/users/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

resource "aws_iam_role_policy_attachment" "developers" {
  role       = aws_iam_role.developers.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_group_policy_attachment" "developers" {
  group = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developers.arn
}

// Require users to have MFA and grant permissions to manage password etc.

resource "aws_iam_group" "mfa_and_password_management" {
  name = "require_mfa"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "require_mfa" {
  group      = aws_iam_group.mfa_and_password_management.name
  policy_arn = aws_iam_policy.require_mfa.arn
}

resource "aws_iam_group_policy_attachment" "password_management" {
  group      = aws_iam_group.mfa_and_password_management.name
  policy_arn = aws_iam_policy.user_password_management.arn
}

// Administrator Users

resource "aws_iam_user" "jfreeman" {
  name = "jfreeman"
  path = "/users/"
}

resource "aws_iam_access_key" "jfreeman" {
  user    = aws_iam_user.jfreeman.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_group_membership" "jfreeman" {
  user   = aws_iam_user.jfreeman.name
  groups = [
    aws_iam_group.administrators.name,
    aws_iam_group.mfa_and_password_management.name
  ]
}

resource "aws_iam_user_login_profile" "jfreeman" {
  user    = aws_iam_user.jfreeman.name
  pgp_key = var.pgp_key
}

// Terraform Service User

resource "aws_iam_user" "terraform" {
  name = "terraform"
  path = "/users/"
  tags = {
    Name        = "Terraform"
    Environment = "Development"
    Owner       = "Ops"
    ServiceUser = "True"
  }
}

resource "aws_iam_access_key" "terraform" {
  user    = aws_iam_user.terraform.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_group_membership" "terraform" {
  user   = aws_iam_user.terraform.name
  groups = [
    aws_iam_group.administrators.name,
    aws_iam_group.mfa_and_password_management.name
  ]
}

resource "aws_iam_user_login_profile" "terraform" {
  user    = aws_iam_user.terraform.name
  pgp_key = var.pgp_key
}
