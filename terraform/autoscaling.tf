resource "aws_appautoscaling_target" "ecs_target" {

  max_capacity       = 5
  min_capacity       = 1

  resource_id        = "service/${aws_ecs_cluster.sales_cluster.name}/${aws_ecs_service.sales_service.name}"

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.sales_service]

}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {

  name               = "cpu-autoscaling"

  policy_type        = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.ecs_target.resource_id

  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension

  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace


  target_tracking_scaling_policy_configuration {

    target_value       = 60.0

    scale_in_cooldown  = 120

    scale_out_cooldown = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

  }

}