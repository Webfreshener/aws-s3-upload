data "aws_iam_policy_document" "_" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "proxy_role" {
  name = "${var.s3_bucket_name}-uploader-role"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document._.json
}

resource "aws_iam_role_policy_attachment" "s3_proxy_role_file_upload_attachment" {
  depends_on = [
    "aws_iam_policy._",
  ]

  role = aws_iam_role.proxy_role.name
  policy_arn = aws_iam_policy._.arn
}

resource "aws_iam_role_policy_attachment" "s3_proxy_role_api_gateway_attachment" {
  depends_on = [
    "aws_iam_policy._",
  ]

  role = aws_iam_role.proxy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}


resource "aws_iam_policy" "_" {
  name = "${var.s3_bucket_name}-uploader-policy"
  path = "/"
  description = "${var.s3_bucket_name} file upload policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "s3:PutObject",
          "s3:ListObject",
          "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
          "arn:aws:s3:::${var.s3_bucket_name}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}
