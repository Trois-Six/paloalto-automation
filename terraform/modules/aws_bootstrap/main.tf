resource "aws_s3_bucket" "this" {
  bucket_prefix = format("%s-s3-", var.name_prefix)
  acl           = "private"
}

resource "aws_s3_bucket_object" "init_cfg" {
  bucket = aws_s3_bucket.this.id
  key    = "config/init-cfg.txt"
  source = abspath(format("%s/%s", path.module, var.init_cfg_path))
}

resource "aws_s3_bucket_object" "bootstrap_xml" {
  bucket = aws_s3_bucket.this.id
  key    = "config/bootstrap.xml"
  source = abspath(format("%s/%s", path.module, var.bootstrap_xml_path))
}

resource "aws_s3_bucket_object" "directories" {
  for_each = toset([
    "content/",
    "software/",
    "plugins/",
    "license/"
  ])

  bucket = aws_s3_bucket.this.id
  key    = each.key
  source = "/dev/null"
}
