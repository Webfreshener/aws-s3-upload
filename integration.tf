resource "aws_api_gateway_integration" "S3Integration" {
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource._.id
  http_method = aws_api_gateway_method._.http_method

  # Included because of this issue: https://github.com/hashicorp/terraform/issues/10501
  integration_http_method = "POST"

  type = "AWS"

  # See uri description: https://docs.aws.amazon.com/apigateway/api-reference/resource/integration/
  uri         = "arn:aws:apigateway:us-east-1:s3:path/*/*"
  credentials = aws_iam_role.proxy_role.arn
}

resource "aws_api_gateway_method_response" "res200" {
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource._.id
  http_method = aws_api_gateway_method._.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "res400" {
  depends_on = [aws_api_gateway_integration.S3Integration]
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource._.id
  http_method = aws_api_gateway_method._.http_method
  status_code = "400"
}

resource "aws_api_gateway_method_response" "res500" {
  depends_on = [aws_api_gateway_integration.S3Integration]
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource._.id
  http_method = aws_api_gateway_method._.http_method
  status_code = "500"
}

resource "aws_api_gateway_integration_response" "res200Integration" {
  depends_on = [aws_api_gateway_integration.S3Integration]
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource._.id
  http_method = aws_api_gateway_method._.http_method
  status_code = aws_api_gateway_method_response.res200.status_code

  response_parameters = {
    "method.response.header.Timestamp"      = "integration.response.header.Date"
    "method.response.header.Content-Length" = "integration.response.header.Content-Length"
    "method.response.header.Content-Type"   = "integration.response.header.Content-Type"
  }
}

resource "aws_api_gateway_integration_response" "res400Integration" {
  depends_on = [aws_api_gateway_integration.S3Integration]

  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource._.id
  http_method = aws_api_gateway_method._.http_method
  status_code = aws_api_gateway_method_response.res400.status_code

  selection_pattern = "4\\d{2}"
}

resource "aws_api_gateway_integration_response" "res500Integration" {
  depends_on = [aws_api_gateway_integration.S3Integration]

  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource._.id
  http_method = aws_api_gateway_method._.http_method
  status_code = aws_api_gateway_method_response.res500.status_code

  selection_pattern = "5\\d{2}"
}
