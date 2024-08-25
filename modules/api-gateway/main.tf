resource "aws_apigatewayv2_api" "main" {
  name          = var.name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_domain_name" "main" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_api_mapping" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  domain_name = aws_apigatewayv2_domain_name.main.id
  stage       = aws_apigatewayv2_stage.main.id
}

resource "aws_apigatewayv2_route" "main" {
  for_each = var.integrations

  api_id    = aws_apigatewayv2_api.main.id
  route_key = each.key

  authorization_type = "NONE"
  target             = "integrations/${aws_apigatewayv2_integration.main[each.key].id}"
}

resource "aws_apigatewayv2_integration" "main" {
  for_each = var.integrations

  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = lookup(each.value, "integration_type")
  integration_method = "GET"
  integration_uri    = lookup(each.value, "integration_uri", null)
  connection_type    = "INTERNET"
}