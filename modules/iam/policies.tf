data "aws_iam_policy_document" "admins_group_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.administrators.arn]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "administrators" {
  name   = "administrators-policy"
  policy = data.aws_iam_policy_document.admins_group_policy.json
}

data "aws_iam_policy_document" "devs_group_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [aws_iam_role.developers.arn]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "developers" {
  name   = "developers-policy"
  policy = data.aws_iam_policy_document.devs_group_policy.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "user_password_management" {
  statement {
    sid    = "AllowViewAccountInfo"
    effect = "Allow"
    actions = [
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowManageOwnPasswords"
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:GetUser"
    ]

    resources = ["arn:aws:iam::*:user/&{aws:username}"]
  }

  statement {
    sid    = "AllowManageOwnAccessKeys"
    effect = "Allow"
    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey"
    ]
    resources = ["arn:aws:iam::*:user/&{aws:username}"]
  }


  statement {
    sid    = "AllowManageOwnSSHPublicKeys"
    effect = "Allow"
    actions = [
      "iam:DeleteSSHPublicKey",
      "iam:GetSSHPublicKey",
      "iam:ListSSHPublicKeys",
      "iam:UpdateSSHPublicKey",
      "iam:UploadSSHPublicKey"
    ]
    resources = ["arn:aws:iam::*:user/&{aws:username}"]
  }
}

resource "aws_iam_policy" "user_password_management" {
  name   = "AllowUsersToSelfManageCredentials"
  policy = data.aws_iam_policy_document.user_password_management.json
}

data "aws_iam_policy_document" "require_mfa" {
  statement {
    sid    = "AllowListActions"
    effect = "Allow"
    actions = [
      "iam:ListUsers",
      "iam:ListVirtualMFADevices"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowIndividualUserToListOnlyTheirMFA"
    effect = "Allow"
    actions = [
      "iam:ListUsers"
    ]
    resources = [
      "arn:aws:iam::*:mfa/*",
      "arn:aws:iam::*:user/&{aws:username}"
    ]
  }
  statement {
    sid    = "AllowIndividualUserToManageTheirOwnMFA"
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice"
    ]
    resources = [
      "arn:aws:iam::*:mfa/&{aws:username}",
      "arn:aws:iam::*:user/&{aws:username}"
    ]
  }
  statement {
    sid    = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"
    effect = "Allow"
    actions = ["iam:DeactivateMFADevice"]
    resources = [
      "arn:aws:iam::*:mfa/&{aws:username}",
      "arn:aws:iam::*:user/&{aws:username}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "require_mfa" {
  name   = "RequireAndAllowUsersToManageOwnMFA"
  policy = data.aws_iam_policy_document.require_mfa.json
}