# Making the bucket

resource "aws_s3_bucket" "file-notification-bpw" {
  bucket = var.bucket-name
  tags = {
    Description = "Bucket to be the source of file notifications"
  }
}

# Creating IAM roles for lambda function

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "file-notification-lambda-role" {
  name               = "file_notification_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Making the lambda function 

resource "aws_lambda_function" "file-notification-lambda" {

  description   = "Lambda function to be activated when a file is placed in S3"
  filename      = "lambda_payload.zip"
  function_name = var.lambda-function-name
  role          = aws_iam_role.file-notification-lambda-role.arn
  handler       = "payload.lambda_handler"

  runtime = var.lambda-runtime

  tags = {
    "Purpose" = "File notification activated lambda"
  }

  environment {
    variables = var.environment-variables
  }
}

# Allowing Lambda to be activated by the bucket

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file-notification-lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.file-notification-bpw.arn
}

# Setting up file notifications

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.file-notification-bpw.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.file-notification-lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.notification-prefix
    filter_suffix       = var.notification-suffix
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

# Enabling logging with the lambda function

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.file-notification-lambda-role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}