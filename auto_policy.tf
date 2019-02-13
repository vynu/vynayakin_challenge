#scale up policy
resource "aws_autoscaling_policy" "asg_policy_up" {
  name                   = "tf-asg-policy-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.bar.name}"
}

# scale down policy
resource "aws_autoscaling_policy" "asg_policy_down" {
  name                   = "tf-asg-policy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.bar.name}"
}

#high cpu usage check
resource "aws_cloudwatch_metric_alarm" "tf-low-cpu-alarm" {
  alarm_name          = "tf-alarm-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.bar.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.asg_policy_up.arn}"]
}

#low cpu usage check
resource "aws_cloudwatch_metric_alarm" "tf-high-cpu-alarm" {
  alarm_name          = "tf-alarm-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.bar.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.asg_policy_down.arn}"]
}
