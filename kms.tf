## Provision KMS Key for encryption
module "encryption" {
    source = "git::https://github.com/arjstack/terraform-aws-kms.git?ref=v1.0.0"
    
    count = var.create_kms_key ? 1 : 0

    account_id = data.aws_caller_identity.this.account_id

    description = format("KMS Key for Timestream [%s] - Data encryption", var.database_name)

    key_spec    = "SYMMETRIC_DEFAULT"
    key_usage   = "ENCRYPT_DECRYPT"

    aliases =  [format("%s-key", var.database_name)]

    key_administrators = [data.aws_caller_identity.this.arn]
    key_grants_users = [data.aws_caller_identity.this.arn]
    key_users = [data.aws_caller_identity.this.arn]

    policy = data.template_file.timestream_access_policy[0].rendered

    tags = merge({ "Timestream" = var.database_name },var.default_tags)
}

## KMS key Policy for giving access to Timestream service
data template_file "timestream_access_policy" {
    count = var.create_kms_key ? 1 : 0
    
    template = file("${path.module}/kms-policy.json")

    vars = {
      aws_account = data.aws_caller_identity.this.account_id
      aws_region  = data.aws_region.current.id
    }
}