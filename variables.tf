variable "create_database" {
    description = "Flag to decide if TImestream Database is provisioned."
    type        = bool
    default     = true
}

variable "database_name" {
    description = "The name of the Timestream database."
    type        = string

    validation {
        condition = length(var.database_name) >= 3 && length(var.database_name) <=64
        error_message = "The database name has a length restrcition of minimum 3 and maximum 64."
    }
}

variable "kms_key_arn" {
    description = "(Optional) ARN of the existing KMS key ARN to encrypt the data stored in the database."
    type        = string
    default     = null
}

variable "create_kms_key" {
    description = "(Optional) Flag to decide if new KMS key (symmetric, encrypt/decrypt) is required for encryption"
    type        = bool
    default     = false
}

variable "tables" {
    description = <<EOF
The List of Map for Timestream tables configurations

name: (Required) The name of the Timestream table.

## Data Retention
magnetic_store_retention_period: (Optional) The duration (in days) for which data must be stored in the magnetic store
memory_store_retention_period: (Optional) The duration (in hours) for which data must be stored in the memory store.

## Magnetic Storage Writes
enable_magnetic_store_writes: (Optional) Flag to decide if magnetic store writes should be enabled.

error_log_location: (Optional) Configuration Map of an S3 location to write error reports for records rejected, asynchronously, during magnetic store writes.
    bucket_name         : (Optional) Bucket name of the customer S3 bucket.
    encryption_option   : (Optional) Encryption option for the customer s3 location. Options are S3 server side encryption with an S3-managed key or KMS managed key.
    kms_key_id          : (Optional) KMS key arn for the customer s3 location when encrypting with a KMS managed key.
    object_key_prefix   : (Optional) Object key prefix for the customer S3 location.

tags: (Optional) A map of tags to assign to the Table.
EOF
    type    = any
    default = []
}

variable "default_tags" {
    description = "(Optional) A map of tags to assign to all the resource."
    type        = map(any)
    default     = {}
}