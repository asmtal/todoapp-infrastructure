
resource "aws_cloudwatch_metric_alarm" "billing" {
  alarm_name          = "billing-alarm-${var.billing_threshold}-${lower(var.currency)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  // 6 hrs
  period        = "21600"
  statistic     = "Maximum"
  threshold     = var.billing_threshold
  alarm_actions = [aws_sns_topic.sns_alert_topic.arn]

  dimensions = {
    Currency = var.currency
  }
}

resource "aws_sns_topic" "sns_alert_topic" {
  name = "billing-alarm-notification-${lower(var.currency)}"
}

resource "aws_sns_topic_subscription" "alert_sms" {
  topic_arn = aws_sns_topic.sns_alert_topic.arn
  protocol  = "sms"
  endpoint  = var.billing_alert_number
}

resource "aws_sns_topic_subscription" "alert_email" {
  topic_arn = aws_sns_topic.sns_alert_topic.arn
  protocol  = "email"
  endpoint  = var.billing_alert_email
}