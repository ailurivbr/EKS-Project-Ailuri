resource "aws_iam_role" "opsuser_role" {
  name = "OpsUserRole-eks"

  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.allowed_account_id}:root"]
    }
    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = [var.allowed_ip]
    }
  }
}

