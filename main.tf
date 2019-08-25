resource "aws_api_gateway_resource" "_" {
  parent_id = var.api_resource_id
  path_part = var.path_part
  rest_api_id = var.api_id
}

resource "aws_api_gateway_method" "_" {
  depends_on = ["aws_api_gateway_resource._"]
  authorization = var.authorization
  http_method = "POST"
  resource_id = aws_api_gateway_resource._.id
  rest_api_id = var.api_id
}

module "cors" {
  source = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  api_id          = var.api_id
  api_resource_id = aws_api_gateway_resource._.id
}
