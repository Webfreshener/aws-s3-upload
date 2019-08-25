output "invoke_url" {
  value = "${aws_api_gateway_deployment.S3APIDeployment.invoke_url}/${aws_api_gateway_resource._.path}"
}
