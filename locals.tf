locals {
    kms_key_arn = (var.create_database 
                        && var.create_kms_key) ? module.encryption[0].key_arn : var.kms_key_arn
}