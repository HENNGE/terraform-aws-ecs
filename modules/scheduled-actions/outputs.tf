output "arn" {
  description = "The Amazon Resource Name (ARN) of the rule."
  value       = aws_cloudwatch_event_rule.rule.arn
}
