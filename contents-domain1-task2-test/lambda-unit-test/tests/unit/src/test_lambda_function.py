import unittest
from moto import mock_aws
import boto3
from lambda_test import lambda_function


class TestNotifyS3Upload(unittest.TestCase):
    bucket_name = "test-bucket"

    def setUp(self):
        # Start the full AWS mock
        self.mock_aws = mock_aws()
        self.mock_aws.start()

        # Create mocked S3 bucket
        s3 = boto3.resource("s3", region_name="ap-northeast-1")
        bucket = s3.Bucket(self.bucket_name)
        bucket.create(
            CreateBucketConfiguration={'LocationConstraint': 'ap-northeast-1'}
        )

        # Put a test object into the bucket to mimic your scenario
        key = "test/key.txt"
        s3.Object(self.bucket_name, key).put(Body=b"hello world")

        # Patch the Lambda class global resource dict to point to mock
        lambda_function._LAMBDA_S3_RESOURCE["resource"] = s3
        lambda_function._LAMBDA_S3_RESOURCE["bucket_name"] = self.bucket_name

        # Create LambdaS3Class instance for tests
        self.s3_class = lambda_function.LambdaS3Class(lambda_function._LAMBDA_S3_RESOURCE)
        self.key = key

    def tearDown(self):
        self.mock_aws.stop()

    def test_notify_s3_upload(self):
        # Call your function directly
        result = lambda_function.notify_s3_upload(self.s3_class, self.key)

        # Assertions
        self.assertIn(self.bucket_name, result)
        self.assertIn(self.key, result)
        self.assertTrue(result.startswith("File uploaded to S3 bucket:"))
