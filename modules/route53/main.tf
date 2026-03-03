resource "aws_acm_certificate" "example" {
  domain_name       = "*.hanimao.com"
  validation_method = "DNS"
}

data "aws_route53_zone" "example" {
  name         = "hanimao.com"
  private_zone = false
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.example.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = var.lb_arn 
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.example.arn

  default_action {
    type             = "forward"
    target_group_arn = var.target_group
  }
}

resource "aws_lb_listener" "front_end_2" {
  load_balancer_arn = var.lb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = "jenkins.hanimao.com"
  type    = "A"

 alias {
    name                   = var.lb_name
    zone_id                = var.lb_hosted_zone
    evaluate_target_health = true
  }
}