resource "aws_s3_bucket" "bootstrap_bucket" {
  bucket_prefix = format("s3-%s-", var.name_suffix)
  acl           = "private"
}

resource "aws_s3_bucket_object" "init_cfg" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "config/init-cfg.txt"
  source = abspath(format("%s/%s", path.module, var.init_cfg_path))
}

resource "aws_s3_bucket_object" "bootstrap_xml" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "config/bootstrap.xml"
  source = abspath(format("%s/%s", path.module, var.bootstrap_xml_path))
}

resource "aws_s3_bucket_object" "content" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "content/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "license" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "license/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "software" {
  bucket = aws_s3_bucket.bootstrap_bucket.id
  key    = "software/"
  source = "/dev/null"
}
