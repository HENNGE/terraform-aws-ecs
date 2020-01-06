resource "aws_iam_role" "instance_role" {
  name = "${var.name}-ecs-instance-role"

  assume_role_policy = data.aws_iam_policy_document.sts_policy.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}-ecs-instance-profile"
  role = aws_iam_role.instance_role.name
}

data "aws_iam_policy_document" "sts_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = aws_iam_role.instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = aws_iam_role.instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
