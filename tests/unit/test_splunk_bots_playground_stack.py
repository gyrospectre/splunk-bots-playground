import aws_cdk as core
import aws_cdk.assertions as assertions

from splunk_bots_playground.splunk_bots_playground_stack import SplunkBotsPlaygroundStack

# example tests. To run these tests, uncomment this file along with the example
# resource in splunk_bots_playground/splunk_bots_playground_stack.py
def test_sqs_queue_created():
    app = core.App()
    stack = SplunkBotsPlaygroundStack(app, "splunk-bots-playground")
    template = assertions.Template.from_stack(stack)

#     template.has_resource_properties("AWS::SQS::Queue", {
#         "VisibilityTimeout": 300
#     })
