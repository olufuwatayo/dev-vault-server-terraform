resource "aws_iam_policy" "Vault_ec2_iam_policy" {
  name        = "Vault_ec2_iam_policy"
  path        = "/"
  description = "Vault_ec2_iam_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "test-attach" {
  name = "Attach to ec2 vault server"

  roles = ["${aws_iam_role.vault_ec2_role.name}"]

  policy_arn = "${aws_iam_policy.Vault_ec2_iam_policy.arn}"
}

resource "aws_iam_role" "vault_ec2_role" {
  name = "vault_ec2_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "vault_ec2__instance_profile" {
  name = "vault_ec2__instance_profile"
  role = "${aws_iam_role.vault_ec2_role.name}"
}
