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

    sid = "AllowAllUsersToListAccounts"

    effect = "Allow"

    actions = [
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
    ]

    resources = [
      "*"
    ]

  }

  statement {

    sid = "AllowIndividualUserToListOnlyTheirOwnMFA"

    effect = "Allow"

    actions = [
      "iam:ListMFADevices",
    ]

    resources = [
      "arn:aws:iam::*:mfa/*",
      "arn:aws:iam::*:user/&{aws:username}"
    ]

  }

  statement {

    sid = "AllowIndividualUserToManageTheirOwnMFA"

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

    sid = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"

    effect = "Allow"

    actions = [
      "iam:DeactivateMFADevice"
    ]

    resources = [
      "arn:aws:iam::*:mfa/&{aws:username}",
      "arn:aws:iam::*:user/&{aws:username}"
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "true"
      ]
    }

  }

  statement {

    sid = "BlockMostAccessUnlessSignedInWithMFA"

    effect = "Deny"

    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:ListVirtualMFADevices",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:ListMFADevices",
      "iam:GetAccountSummary",
    ]

    resources = [
      "*"
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"

      values = [
        "false",
      ]
    }
  }
}

resource "aws_iam_policy" "require_mfa" {
  name   = "RequireAndAllowUsersToManageOwnMFA"
  policy = data.aws_iam_policy_document.require_mfa.json
}