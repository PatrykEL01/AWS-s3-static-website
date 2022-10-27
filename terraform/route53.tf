resource "aws_route53_zone" "main" {
  name = "devtestwebsite.com"
}

resource "aws_route53_record" "static_web" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "devtestwebsite.com"
  type    = "A"
  alias {
    name = aws_cloudfront_distribution.www_s3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.www_s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
  depends_on = [
    module.s3_bucket
  ]
}