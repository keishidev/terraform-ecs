resource "aws_ecs_cluster" "cluster" {
  name = "${var.vpc}-cluster"
}

resource "aws_autoscaling_group" "cluster" {
  name = "${var.vpc}-auto-scaling-group"
  max_size = 2
  min_size = 1
  desired_capacity = 2
  launch_configuration = "${aws_launch_configuration.cluster.name}"
  vpc_zone_identifier = ["${aws_subnet.main-1a.id}", "${aws_subnet.main-1b.id}","${aws_subnet.main-1d.id}","${aws_subnet.main-1e.id}"]

  tag {
    key = "Name"
    value = "${var.vpc}-cluster-instance"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "cluster" {
    name_prefix = "${var.vpc}-"
    image_id = "ami-4fe4852a"
    instance_type = "t2.nano"
    iam_instance_profile = "${aws_iam_instance_profile.instance_profile.name}"
    security_groups = ["${aws_security_group.cluster.id}"]
    key_name = "${aws_key_pair.instance.key_name}"
    user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
EOF
    user_data = 
}

