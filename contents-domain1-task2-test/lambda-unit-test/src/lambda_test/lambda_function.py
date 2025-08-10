from os import environ
from boto3 import resource

_LAMBDA_S3_RESOURCE = { "resource" : resource('s3'), 
                        "bucket_name" : environ.get("S3_BUCKET_NAME","NONE") }

class LambdaS3Class:
    def __init__(self, lambda_s3_resource):  
        self.resource = lambda_s3_resource["resource"]
        self.bucket_name = lambda_s3_resource["bucket_name"]
        self.bucket = self.resource.Bucket(self.bucket_name)

def notify_s3_upload(s3: LambdaS3Class, key: str):
    bucket = s3.bucket_name
    # obj = s3.bucket.get_object(Bucket = bucket, Key = key)
    obj = s3.bucket.Object(key)
    
    return f"File uploaded to S3 bucket: {bucket}, key: {obj.key}"
    
def handler(event, context):
    ######################
    # Lambda Entry Point #
    ######################
    
    s3_resource_class = LambdaS3Class(_LAMBDA_S3_RESOURCE)
    added_key = event["Records"][0]["s3"]["object"]["key"]
    return notify_s3_upload(s3 = s3_resource_class, key = added_key)