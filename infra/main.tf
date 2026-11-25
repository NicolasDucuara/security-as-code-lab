# Infraestructura de ejemplo corregida. No ejecutar terraform apply.
# Configuración segura: bucket S3 con bloqueo total de acceso público, cifrado y versionado.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "lab_data" {
  #checkov:skip=CKV_AWS_18:Logging de acceso no requerido para entorno de laboratorio
  #checkov:skip=CKV_AWS_144:Replicación entre regiones no requerida para este entorno
  #checkov:skip=CKV_AWS_145:Cifrado con KMS gestionado por el cliente omitido; se utiliza SSE-S3 estándar
  #checkov:skip=CKV2_AWS_61:Políticas de ciclo de vida no requeridas en bucket de demostración
  #checkov:skip=CKV2_AWS_62:Notificaciones de eventos no requeridas en bucket de demostración
  bucket = "security-as-code-lab-public-example-123456"
}

resource "aws_s3_bucket_versioning" "lab_data_versioning" {
  bucket = aws_s3_bucket.lab_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lab_data_encryption" {
  bucket = aws_s3_bucket.lab_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "lab_data_ownership" {
  bucket = aws_s3_bucket.lab_data.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "lab_data" {
  bucket                  = aws_s3_bucket.lab_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
