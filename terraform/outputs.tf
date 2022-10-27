output "s3_arn"{
    value = module.s3_bucket.s3_bucket_arn
}

output "s3_bucket_website_endpoint"{
    value = module.s3_bucket.s3_bucket_website_endpoint
}

output "s3_bucket_website_domain"{
    value = module.s3_bucket.s3_bucket_website_domain

depends_on = [
  module.s3_bucket
]
}
