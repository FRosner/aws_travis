locals {
  website_bucket_name = "${local.project_name}-${terraform.workspace}-website"
}

resource "aws_s3_bucket" "website" {
  bucket = "${local.website_bucket_name}"
  acl    = "public-read"
  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[
      {
        "Sid":"PublicReadGetObject",
        "Effect":"Allow",
        "Principal": "*",
        "Action":["s3:GetObject"],
        "Resource":["arn:aws:s3:::${local.website_bucket_name}/*"]
      }
    ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags {
    Environment = "${terraform.workspace}"
  }
}

locals {
  site_root = "website/static/_site"
  index_html = "${local.site_root}/index.html"
  about_html = "${local.site_root}/about/index.html"
  post_html = "${local.site_root}/jekyll/update/2018/06/30/welcome-to-jekyll.html"
  error_html = "${local.site_root}/404.html"
  main_css = "${local.site_root}/assets/main.css"
}

resource "aws_s3_bucket_object" "index" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "index.html"
  source = "${local.index_html}"
  etag   = "${md5(file(local.index_html))}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "post" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "jekyll/update/2018/06/30/welcome-to-jekyll.html"
  source = "${local.post_html}"
  etag   = "${md5(file(local.post_html))}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "about" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "about/index.html"
  source = "${local.about_html}"
  etag   = "${md5(file(local.about_html))}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "error.html"
  source = "${local.error_html}"
  etag   = "${md5(file(local.error_html))}"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "css" {
  bucket = "${aws_s3_bucket.website.id}"
  key    = "assets/main.css"
  source = "${local.main_css}"
  etag   = "${md5(file(local.main_css))}"
  content_type = "text/css"
}

output "url" {
  value = "http://${local.website_bucket_name}.s3-website.${aws_s3_bucket.website.region}.amazonaws.com"
}