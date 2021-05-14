data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        principals {
            type = "AWS"
            identifiers = ["arn:aws:iam::${var.AWS_ACCOUNT_ID}:root"]
        }
    }
}

data "aws_iam_policy_document" "developers-group-policy" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        resources = [aws_iam_role.developers.arn]
    }
}


resource "aws_iam_policy" "developers" {
    name = "developers-policy"
}

data "aws_iam_policy_document" "admins-group-policy" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]

        resources = [aws_iam_role.developers.arn]
    }
}

resource "aws_iam_role" "administrators" {
  name               = "administrators"
  path               = ""
  assume_role_policy = data.aws_iam_policy_document.dev-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "administrators" {
  role       = aws_iam_role.administrators.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_policy" "administrators" {
    name = "developers-policy"
}

resource "aws_iam_group" "administrators" {
  name = "administrators"
  path = "/users/"
}

resource "aws_iam_role" "developers" {
  name               = "developers"
  path               = ""
  assume_role_policy = data.aws_iam_policy_document.developers_assume_role.json
}

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}