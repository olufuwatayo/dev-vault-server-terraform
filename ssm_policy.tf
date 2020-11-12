# <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ssm:StartSession",
#                 "ssm:SendCommand" 
#             ],
#             "Resource": [
#                 "arn:aws:ec2:*:*:instance/instance-id",
#                 "arn:aws:ssm:region:account-id:document/SSM-SessionManagerRunShell" 
#             ],
#             "Condition": {
#                 "BoolIfExists": {
#                     "ssm:SessionDocumentAccessCheck": "true" 
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ssm:DescribeSessions",
#                 "ssm:GetConnectionStatus",
#                 "ssm:DescribeInstanceInformation",
#                 "ssm:DescribeInstanceProperties",
#                 "ec2:DescribeInstances"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ssm:TerminateSession"
#             ],
#             "Resource": [
#                 "arn:aws:ssm:*:*:session/${aws:username}-*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "kms:GenerateDataKey" 
#             ],
#             "Resource": "key-name"
#         }
#     ]
# }
# EOF