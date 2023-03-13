from aws_cdk import (
    Stack,
    aws_ec2 as ec2,
    aws_ecs as ecs,
    aws_ecs_patterns as ecs_patterns,
    aws_ecr as ecr
)
from constructs import Construct

class SplunkBotsPlaygroundStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        _repo = ecr.Repository.from_repository_name(self,'splunkRepo','splunk_playground')

        vpc = ec2.Vpc(self, "SplunkVpc", max_azs=2)
        cluster = ecs.Cluster(self, "SplunkCluster", vpc=vpc)

        ecs_patterns.ApplicationLoadBalancedFargateService(self, "SplunkService",
            cluster=cluster,
            listenerPort=8000,
            cpu=256,
            desired_count=1,
            task_image_options=ecs_patterns.ApplicationLoadBalancedTaskImageOptions(
                image=ecs.ContainerImage.from_ecr_repository(_repo)
            ),
            memory_limit_mib=512,
            public_load_balancer=True
        )
