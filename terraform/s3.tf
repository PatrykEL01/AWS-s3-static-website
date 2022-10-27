module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.4.0"

create_bucket = true
bucket = var.bucket_name
acl    = "public-read"
force_destroy = true
  versioning = {
    enabled = true
  }

  website = {
    # conflicts with "error_document"
    #        redirect_all_requests_to = {
    #          host_name = "https://modules.tf"
    #        }

    index_document = "index.html"

  }
}



resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/../src ${var.destonation}"
  }
  depends_on = [
    module.s3_bucket
  ]
}


/* resource "aws_s3_bucket_website_configuration" "s3_static_web" {
  bucket = var.bucket_name

  index_document {
    suffix = "index.html"
  }

} */

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = var.bucket_name

  acl = "public-read"
}


resource "aws_s3_bucket_policy" "s3_policy" {
   bucket = var.bucket_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          module.s3_bucket.s3_bucket_arn,
          "${module.s3_bucket.s3_bucket_arn}/*",
        ]
      },
    ]
  })
}