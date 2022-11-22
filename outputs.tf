output "database_arn" {
    description = "The ARN that uniquely identifies this database."
    value       = var.create_database ? aws_timestreamwrite_database.this[0].arn : ""
}

output "kms_key_id" {
    description = "The ARN of the KMS key used to encrypt the data stored in the database."
    value       = var.create_database ? aws_timestreamwrite_database.this[0].arn : ""
}

output "tables" {
    description = "The ARN of the Timestream tables."
    value       = { for key, table in aws_timestreamwrite_table.this: key => table.arn }
}