locals {
  dns_zone_name = "prod.nulldutra.me"
}

module "route53_zone" {
  source = "./modules/route53-zone"

  name = local.dns_zone_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.0"

  domain_name               = local.dns_zone_name
  subject_alternative_names = ["*.${local.dns_zone_name}"]
  zone_id                   = module.route53_zone.zone_id
  validation_method         = "DNS"
  wait_for_validation       = true
}

module "acm_fallback" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.fallback
  }

  domain_name               = local.dns_zone_name
  subject_alternative_names = ["*.${local.dns_zone_name}"]
  zone_id                   = module.route53_zone.zone_id
  validation_method         = "DNS"
  wait_for_validation       = true
}

module "api_gateway" {
  source = "./modules/api-gateway"

  name            = "api-http"
  certificate_arn = module.acm.acm_certificate_arn
  domain_name     = "api.${local.dns_zone_name}"
  integrations = {
    "GET /v1/test" = {
      integration_type = "HTTP_PROXY"
      integration_uri  = "https://run.mocky.io/v3/cd3a6cf8-7f2e-4c17-a142-7ed63ca6eb23"
    }
  }
}

module "api_gateway_fallback" {
  source = "./modules/api-gateway"

  providers = {
    aws = aws.fallback
  }

  name            = "api-http-fallback"
  certificate_arn = module.acm_fallback.acm_certificate_arn
  domain_name     = "api.${local.dns_zone_name}"
  integrations = {
    "GET /v1/test" = {
      integration_type = "HTTP_PROXY"
      integration_uri  = "https://run.mocky.io/v3/4a8d31a4-1d71-4c90-a32a-583657446467"
    }
  }
}

module "cloudfront" {
  source = "./modules/cloudfront"

  origins = {
    prod = {
      domain_name = replace(module.api_gateway.api_endpoint, "https://", "")
      origin_id   = "prod"
    },
    fallback = {
      domain_name = replace(module.api_gateway_fallback.api_endpoint, "https://", "")
      origin_id   = "fallback"
    }
  }

  target_origin_id = "fallback"

  aliases                  = ["api.${local.dns_zone_name}"]
  acm_certificate_arn      = module.acm.acm_certificate_arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
}

module "route53_record" {
  source = "./modules/route53-record"

  zone_id       = module.route53_zone.zone_id
  name          = "api.${local.dns_zone_name}"
  type          = "A"
  alias_name    = module.cloudfront.domain_name
  alias_zone_id = module.cloudfront.hosted_zone_id
}
