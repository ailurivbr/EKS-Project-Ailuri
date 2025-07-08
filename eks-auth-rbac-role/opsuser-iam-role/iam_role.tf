data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.user_arn]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = [var.source_ip]
    }
  }
}

resource "aws_iam_role" "opsuser_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
