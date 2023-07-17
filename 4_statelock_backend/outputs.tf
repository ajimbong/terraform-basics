output "dynamodb-table-name"{
    value = aws_dynamodb_table.statelock.name
}

output "s3-bucket-name"{
    value = aws_s3_bucket.state-bucket.bucket
}