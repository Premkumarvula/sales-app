resource "aws_sns_topic" "alerts" {
  name = "sales-app-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "vulapremkumar7@gmail.com"
}

############################
# ECS CPU Alarm
############################

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {

  alarm_name          = "ecs-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    ClusterName = aws_ecs_cluster.sales_cluster.name
    ServiceName = aws_ecs_service.sales_service.name
  }

  alarm_description = "ECS CPU usage too high"

  alarm_actions = [aws_sns_topic.alerts.arn]

}

############################
# ECS Memory Alarm
############################

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {

  alarm_name          = "ecs-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75

  dimensions = {
    ClusterName = aws_ecs_cluster.sales_cluster.name
    ServiceName = aws_ecs_service.sales_service.name
  }

  alarm_description = "ECS Memory usage too high"

  alarm_actions = [aws_sns_topic.alerts.arn]

}

############################
# ALB 5XX Error Alarm
############################

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {

  alarm_name          = "alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  dimensions = {
    LoadBalancer = aws_lb.this.arn_suffix
  }

  alarm_description = "Too many ALB 5XX errors"

  alarm_actions = [aws_sns_topic.alerts.arn]

}